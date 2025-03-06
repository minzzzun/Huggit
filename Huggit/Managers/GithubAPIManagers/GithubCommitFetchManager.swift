//
// GithubCommitManager.swift
// Huggit
//
// Created by Minhyeok Kim on 3/4/25.

import Foundation

final class GithubCommitFetchManager {
    static let shared = GithubCommitFetchManager()
    private init() {}
    
    // 일정 기간내 날짜별 커밋 수
    func fetchContributionCountsInPeriod(username: String,
                            from startDate: Date,
                            to endDate: Date,
                            completion: @escaping (Result<[String: Int], GithubAPIError>) -> Void) {
        let isoFormatter = ISO8601DateFormatter()
        let fromStr = isoFormatter.string(from: startDate)
        let toStr = isoFormatter.string(from: endDate)
        
        let query = GithubGraphQLQueries.contributionsCalendarQuery(username: username, from: fromStr, to: toStr)
        print("GraphQL Query:\n\(query)")
        
        GithubGraphQLManager.shared.request(query: query) { (result: Result<ContributionCountsInPeriodResponse, GithubAPIError>) in
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
    
    // 특정 날짜에 대한 커밋 내용
    func fetchContributionDetails(for username: String,
                                      on date: Date,
                                      completion: @escaping (Result<[ContributionDetail], GithubAPIError>) -> Void) {
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
            
            let query = GithubGraphQLQueries.nonCommitContributionDetailsQuery(username: username, from: fromStr, to: toStr)
            print("GraphQL Non-Commit Contribution Details Query:\n\(query)")
            
            GithubGraphQLManager.shared.request(query: query) { (result: Result<ContributionDetailsResponse, GithubAPIError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let collection = response.data.user.contributionsCollection
                        
                        // non-commit contributions (PR, Issue, Repository 생성) → [repositoryName: [message]]
                        var nonmessagesByRepo: [String: [String]] = [:]
                        
                        if let prGroup = collection.pullRequestContributions {
                            for prNode in prGroup.nodes {
                                let repoName = prNode.pullRequest.repository.name
                                nonmessagesByRepo[repoName, default: []].append(prNode.pullRequest.title)
                            }
                        }
                        
                        if let issueGroup = collection.issueContributions {
                            for issueNode in issueGroup.nodes {
                                let repoName = issueNode.issue.repository.name
                                nonmessagesByRepo[repoName, default: []].append(issueNode.issue.title)
                            }
                        }
                        
                        if let repoGroup = collection.repositoryContributions {
                            for repoNode in repoGroup.nodes {
                                let repoName = repoNode.repository.name
                                nonmessagesByRepo[repoName, default: []].append("Repository created")
                            }
                        }
                        
                        // commit contributions: commitContributionsByRepository에서 가져온 레파지토리 목록 (커밋 메시지는 없음)
                        let commitRepoList = collection.commitContributionsByRepository
                        var messagesByRepo: [String: [String]] = [:]
                        let group = DispatchGroup()
                        
                        // 각 레파지토리에 대해 commit history 쿼리를 실행하여 실제 커밋 메시지를 가져옴
                        for commitContribution in commitRepoList {
                            let repoName = commitContribution.repository.name
                            let owner = commitContribution.repository.owner.login
                            group.enter()
                            
                            let historyQuery = GithubGraphQLQueries.contributionHistoryQuery(owner: owner, repoName: repoName, from: fromStr, to: toStr)
                            print("GraphQL History Query for \(repoName):\n\(historyQuery)")
                            
                            GithubGraphQLManager.shared.request(query: historyQuery) { (historyResult: Result<RepoContributionDetailsResponse, GithubAPIError>) in
                                DispatchQueue.main.async {
                                    switch historyResult {
                                    case .success(let historyResponse):
                                        if let nodes = historyResponse.data?.repository.defaultBranchRef?.target.history.nodes {
                                            let messages = nodes.filter { $0.author?.user?.login == username }.map { $0.message }
                                            messagesByRepo[repoName] = messages
                                        }
                                    case .failure(let error):
                                        print("History fetch error for \(repoName): \(error)")
                                    }
                                    group.leave()
                                }
                            }
                        }
                        
                        group.notify(queue: .main) {
                            // merge non-commit messages and commit messages by repository name
                            var contributionsByRepo: [String: [String]] = nonmessagesByRepo
                            for (repoName, messages) in messagesByRepo {
                                contributionsByRepo[repoName, default: []].append(contentsOf: messages)
                            }
                            
                            // 최종 ContributionDetail 배열 생성
                            let details = contributionsByRepo.map { (repoName, messages) in
                                ContributionDetail(repositoryName: repoName, messages: messages)
                            }
                            
                            print("모든 contribution 내역 조회 완료. 총 \(details.count) 건")
                            completion(.success(details))
                        }
                        
                    case .failure(let error):
                        print("GraphQL Contributions fetch error: \(error)")
                        completion(.failure(error))
                    }
                }
            }
        }
}
