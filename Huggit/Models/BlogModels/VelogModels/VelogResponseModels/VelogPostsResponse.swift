//
//  VelogPostsResponse.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/11/25.
//

struct VelogPostsResponse: Decodable {
    let data: VelogPostData
}

struct VelogPostData: Decodable {
    let posts: [VelogPost]
}

struct VelogPost: Decodable {
    let title: String
    let short_description: String
    let url_slug: String
    let updated_at: String
}
