//
//  GithubGraphQLQueries.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

struct GithubGraphQLQueries {
    static func contributionsQuery(username: String, from: String, to: String) -> String {
        return """
        query {
          user(login: "\(username)") {
            contributionsCollection(from: "\(from)", to: "\(to)") {
              commitContributionsByRepository {
                repository {
                  name
                  owner {
                    login
                  }
                }
              }
            }
          }
        }
        """
    }
    
    static func historyQuery(owner: String, repoName: String, from: String, to: String) -> String {
        return """
        query {
          repository(owner: "\(owner)", name: "\(repoName)") {
            defaultBranchRef {
              target {
                ... on Commit {
                  history(since: "\(from)", until: "\(to)", first: 100) {
                    nodes {
                      message
                      author {
                        user {
                          login
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """
    }
    
    static func contributionsCalendarQuery(username: String, from: String, to: String) -> String {
        return """
        query {
          user(login: "\(username)") {
            contributionsCollection(from: "\(from)", to: "\(to)") {
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
    }
}
