//
//  ContributionCountsInPeriodResponse.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

// 일별 커밋 수를 가져오기 위한 모델
struct ContributionCountsInPeriodResponse: Decodable {
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
