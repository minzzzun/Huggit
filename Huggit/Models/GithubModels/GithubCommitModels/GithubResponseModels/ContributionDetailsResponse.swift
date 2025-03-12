//
// ContributionDetailsResponse.swift
// Huggit
//
// Created by Minhyeok Kim on 3/4/25.

import Foundation

struct ContributionDetailsResponse: Decodable {
    let data: DataClass
    struct DataClass: Decodable {
        let user: User
        struct User: Decodable {
            let contributionsCollection: ContributionsCollection
            struct ContributionsCollection: Decodable {
                let commitContributionsByRepository: [CommitContribution]
                let pullRequestContributions: ContributionsGroup<PullRequestNode>?
                let issueContributions: ContributionsGroup<IssueNode>?
                let repositoryContributions: ContributionsGroup<RepositoryNode>?
                
                struct CommitContribution: Decodable {
                    let repository: Repository
                    struct Repository: Decodable {
                        let name: String
                        let owner: Owner
                        struct Owner: Decodable {
                            let login: String
                        }
                    }
                }
                
                struct ContributionsGroup<Node: Decodable>: Decodable {
                    let nodes: [Node]
                }
                
                struct PullRequestNode: Decodable {
                    let pullRequest: PullRequest
                    struct PullRequest: Decodable {
                        let title: String
                        let repository: Repository
                        struct Repository: Decodable {
                            let name: String
                        }
                    }
                }
                
                struct IssueNode: Decodable {
                    let issue: Issue
                    struct Issue: Decodable {
                        let title: String
                        let repository: Repository
                        struct Repository: Decodable {
                            let name: String
                        }
                    }
                }
                
                struct RepositoryNode: Decodable {
                    let repository: Repository
                    struct Repository: Decodable {
                        let name: String
                    }
                }
            }
        }
    }
}
