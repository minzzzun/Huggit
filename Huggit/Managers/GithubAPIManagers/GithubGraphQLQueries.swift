//
//  GithubGraphQLQueries.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

struct GithubGraphQLQueries {
    static func contributionCountsInPeriodQuery(username: String, from: String, to: String) -> String {
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
    
    static func nonCommitContributionDetailsQuery(username: String, from: String, to: String) -> String {
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
                  pullRequestContributions(first: 100) {
                    nodes {
                      pullRequest {
                        title
                        repository {
                          name
                        }
                      }
                    }
                  }
                  issueContributions(first: 100) {
                    nodes {
                      issue {
                        title
                        repository {
                          name
                        }
                      }
                    }
                  }
                  repositoryContributions(first: 100) {
                    nodes {
                      repository {
                        name
                      }
                    }
                  }
                }
              }
            }
            """
        }
        
        // 해당 레파지토리의 commit history (실제 커밋 메시지)
        static func contributionHistoryQuery(owner: String, repoName: String, from: String, to: String) -> String {
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
}
