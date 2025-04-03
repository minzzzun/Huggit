//
//  Post.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/7/25.
//

import Foundation

enum PostType: Equatable {
    case tistory
    case velog
}

struct Post: Identifiable, Equatable {
    let id = UUID()
    let type: PostType
    let date: Date
    let link: String
    let title: String
    let summary: String
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
