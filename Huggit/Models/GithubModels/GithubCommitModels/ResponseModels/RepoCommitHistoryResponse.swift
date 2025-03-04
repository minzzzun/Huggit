//
// RepoCommitHistoryResponse.swift
// Huggit
//
// Created by Minhyeok Kim on 3/4/25.

import Foundation

struct RepoCommitHistoryResponse: Decodable {
    let data: DataClass?
    let errors: [GraphQLError]?
    
    struct DataClass: Decodable {
        let repository: Repository
        struct Repository: Decodable {
            let defaultBranchRef: DefaultBranchRef?
            struct DefaultBranchRef: Decodable {
                let target: Target
                struct Target: Decodable {
                    let history: History
                    struct History: Decodable {
                        let nodes: [CommitNode]
                        struct CommitNode: Decodable {
                            let message: String
                            let author: Author?
                            
                            struct Author: Decodable {
                                let user: GithubUser?
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct GraphQLError: Decodable {
        let message: String
    }
}
