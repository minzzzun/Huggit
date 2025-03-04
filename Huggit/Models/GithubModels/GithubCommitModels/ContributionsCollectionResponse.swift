//
//  ContributionsCollectionResponse.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

struct ContributionsCollectionResponse: Decodable {
    struct Data: Decodable {
        struct User: Decodable {
            struct ContributionsCollection: Decodable {
                struct ContributionCalendar: Decodable {
                    struct Week: Decodable {
                        struct ContributionDay: Decodable {
                            let date: String
                            let contributionCount: Int
                        }
                        let contributionDays: [ContributionDay]
                    }
                    let weeks: [Week]
                }
                let contributionCalendar: ContributionCalendar
            }
            let contributionsCollection: ContributionsCollection
        }
        let user: User
    }
    let data: Data
}
