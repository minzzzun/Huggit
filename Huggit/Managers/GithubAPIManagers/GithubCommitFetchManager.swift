//
// GithubCommitManager.swift
// Huggit
//
// Created by Minhyeok Kim on 3/4/25.

import Foundation

final class GithubCommitFetchManager {
    static let shared = GithubCommitFetchManager()
    private init() {}
    
    // 특정 날짜에 대한 커밋 내용
    func fetchCommitHistory(for username: String,
                            on date: Date,
                            completion: @escaping (Result<[CommitDetail], GithubAPIError>) -> Void) {
        let calendar = Calendar(identifier: .gregorian)
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        let fromStr = isoFormatter.string(from: startOfDay)
        let toStr = isoFormatter.string(from: endOfDay)
        
        // contributions 쿼리
        let contributionsQuery = GithubGraphQLQueries.contributionsQuery(username: username, from: fromStr, to: toStr)
        print("GraphQL Contributions Query:\n\(contributionsQuery)")
        
        GithubGraphQLManager.shared.request(query: contributionsQuery) { (result: Result<CommitContributionsResponse, GithubAPIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let contributions = response.data.user.contributionsCollection.commitContributionsByRepository
                    if contributions.isEmpty {
                        print("GraphQL Contributions fetch: 데이터 없음")
                        completion(.failure(.decodingError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "데이터 없음"]))))
                        return
                    }
                    
                    var details: [CommitDetail] = []
                    let group = DispatchGroup()
                    
                    // 각 레파지토리별 commit history 쿼리 실행
                    for contribution in contributions {
                        let repoName = contribution.repository.name
                        let owner = contribution.repository.owner.login
                        group.enter()
                        
                        let historyQuery = GithubGraphQLQueries.historyQuery(owner: owner, repoName: repoName, from: fromStr, to: toStr)
                        print("GraphQL History Query for \(repoName):\n\(historyQuery)")
                        
                        GithubGraphQLManager.shared.request(query: historyQuery) { (historyResult: Result<RepoCommitHistoryResponse, GithubAPIError>) in
                            DispatchQueue.main.async {
                                switch historyResult {
                                case .success(let historyResponse):
                                    if let errors = historyResponse.errors, !errors.isEmpty {
                                        let errorMessages = errors.map { $0.message }.joined(separator: ", ")
                                        print("GraphQL History fetch error for \(repoName): \(errorMessages)")
                                        details.append(CommitDetail(repositoryName: repoName, commitMessages: []))
                                    } else if let nodes = historyResponse.data?.repository.defaultBranchRef?.target.history.nodes {
                                        let messages = nodes.filter {
                                            $0.author?.user?.login == username
                                        }.map { $0.message }
                                        details.append(CommitDetail(repositoryName: repoName, commitMessages: messages))
                                    } else {
                                        print("GraphQL History fetch: \(repoName)에서 데이터 없음")
                                        details.append(CommitDetail(repositoryName: repoName, commitMessages: []))
                                    }
                                case .failure(let error):
                                    print("GraphQL History fetch error for \(repoName): \(error)")
                                    details.append(CommitDetail(repositoryName: repoName, commitMessages: []))
                                }
                                group.leave()
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        print("모든 레파지토리에 대한 커밋 히스토리 조회 완료")
                        completion(.success(details))
                    }
                    
                case .failure(let error):
                    print("GraphQL Contributions fetch error: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    // 날짜별 커밋 수
    func fetchContributions(username: String,
                            from startDate: Date,
                            to endDate: Date,
                            completion: @escaping (Result<[String: Int], GithubAPIError>) -> Void) {
        let isoFormatter = ISO8601DateFormatter()
        let fromStr = isoFormatter.string(from: startDate)
        let toStr = isoFormatter.string(from: endDate)
        
        let query = GithubGraphQLQueries.contributionsCalendarQuery(username: username, from: fromStr, to: toStr)
        print("GraphQL Query:\n\(query)")
        
        GithubGraphQLManager.shared.request(query: query) { (result: Result<ContributionsCollectionResponse, GithubAPIError>) in
            switch result {
            case .success(let response):
                var countsByDate: [String: Int] = [:]
                for week in response.data.user.contributionsCollection.contributionCalendar.weeks {
                    for day in week.contributionDays {
                        countsByDate[day.date] = day.contributionCount
                    }
                }
                print("GraphQL Response countsByDate: \(countsByDate)")
                completion(.success(countsByDate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
