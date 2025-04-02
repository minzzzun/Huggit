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
            "variables": [
                "username": username,
                "cursor": NSNull(),
                "limit": 3
            ],
            "query": """
                    query Posts($cursor: ID, $username: String!, $limit: Int) {
                      posts(cursor: $cursor, username: $username, limit: $limit) {
                        title
                        short_description
                        url_slug
                        updated_at
                      }
                    }
                    """
        ]
    }
    
    static func fetchUserQuery(username: String) -> [String: Any] {
        return [
            "operationName": "IsVelogUser",
            "variables": ["username": username],
            "query": """
                query IsVelogUser($username: String!) {
                  user(username: $username) {
                    id
                    username
                  }
                }
                """
        ]
    }
}
