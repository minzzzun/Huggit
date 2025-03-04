//
// CommitContributionsResponse.swift
// Huggit
//
// Created by Minhyeok Kim on 3/4/25.

import Foundation

struct CommitContributionsResponse: Decodable {
    let data: DataClass
    struct DataClass: Decodable {
        let user: User
        struct User: Decodable {
            let contributionsCollection: ContributionsCollection
            struct ContributionsCollection: Decodable {
                let commitContributionsByRepository: [CommitContribution]
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
            }
        }
    }
}
