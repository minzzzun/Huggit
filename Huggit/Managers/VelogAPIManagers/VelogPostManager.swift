//
//  VelogPostManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/11/25.
//

import Foundation

final class VelogPostManager {
    static let shared = VelogPostManager()
    private init() {}
    
    func fetchVelogPosts(username: String, completion: @escaping ([Post]) -> Void) {
        let query = VelogGraphQLQueries.fetchRecentPostsQuery(username: username)
        VelogGraphQLManager.shared.request(query: query) { (result: Result<VelogPostsResponse, Error>) in
            switch result {
            case .success(let response):
                let posts = response.data.posts.map { post in
                    Post(
                        type: .velog,
                        date: ISO8601DateFormatter().date(from: post.updated_at) ?? Date(),
                        link: "https://velog.io/@\(username)/\(post.url_slug)",
                        title: post.title,
                        summary: post.short_description
                    )
                }
                completion(posts)
            case .failure(let error):
                print("❌ Velog 데이터 요청 실패: \(error)")
                completion([])
            }
        }
    }
}
