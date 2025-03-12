//
//  VelogGraphQLQueries.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/11/25.
//

import Foundation

struct VelogGraphQLQueries {
    static func fetchRecentPostsQuery(username: String) -> [String: Any] {
        return [
            "operationName": "Posts",
            "variables": ["username": username],
            "query": """
            query Posts($username: String!) {
              posts(username: $username) {
                title
                short_description
                url_slug
                updated_at
              }
            }
            """
        ]
    }
}
