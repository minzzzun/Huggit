//
//  GithubCommitManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

final class GithubCommitManager {
    static let shared = GithubCommitManager()
    private init() {}
    
    /// 사용자 이벤트(PushEvent 포함)를 가져오는 함수
    func fetchUserEvents(username: String,
                         completion: @escaping (Result<[GithubEvent], GithubAPIError>) -> Void) {
        let endpoint = "/users/\(username)/events/public"
        GithubRestManager.shared.request(endpoint: endpoint,
                                         method: .GET,
                                         parameters: nil,
                                         completion: completion)
    }
    
    /// 특정 날짜에 대한 커밋 이력을 집계하는 함수.
    func fetchCommitHistory(for username: String,
                            on date: Date,
                            completion: @escaping (Result<DayCommitHistory, GithubAPIError>) -> Void) {
        fetchUserEvents(username: username) { result in
            switch result {
            case .success(let events):
                let isoFormatter = ISO8601DateFormatter()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let targetDateString = dateFormatter.string(from: date)
                
                var repoDict: [String: [String]] = [:]
                var totalCommitCount = 0
                
                for event in events where event.type == "PushEvent" {
                    if let eventDate = isoFormatter.date(from: event.created_at) {
                        let eventDateString = dateFormatter.string(from: eventDate)
                        if eventDateString == targetDateString {
                            let repoName = event.repo.name
                            let commitCount = event.payload.size ?? 0
                            totalCommitCount += commitCount
                            if let commits = event.payload.commits {
                                let messages = commits.map { $0.message }
                                repoDict[repoName, default: []].append(contentsOf: messages)
                            }
                        }
                    }
                }
                let commitDetails = repoDict.map { CommitDetail(repositoryName: $0.key, commitMessages: $0.value) }
                let history = DayCommitHistory(totalCommitCount: totalCommitCount,
                                               commitDetails: commitDetails)
                completion(.success(history))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// GraphQL API를 사용해 contributionsCollection을 가져와 전체 커밋 수를 날짜별로 집계하는 함수
    func fetchContributions(username: String,
                            from startDate: Date,
                            to endDate: Date,
                            completion: @escaping (Result<[String: Int], GithubAPIError>) -> Void) {
        let isoFormatter = ISO8601DateFormatter()
        let fromStr = isoFormatter.string(from: startDate)
        let toStr = isoFormatter.string(from: endDate)
        
        let query = """
        query {
          user(login: "\(username)") {
            contributionsCollection(from: "\(fromStr)", to: "\(toStr)") {
              contributionCalendar {
                weeks {
                  contributionDays {
                    date
                    contributionCount
                  }
                }
              }
            }
          }
        }
        """
        
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
