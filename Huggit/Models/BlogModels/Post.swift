//
//  Post.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/7/25.
//

import Foundation

enum PostType {
    case tistory
    case velog
}

struct Post {
    let id = UUID()
    let type: PostType
    let date: Date
    let link: String
    let title: String
    let summary: String
}
