//
//  GithubEvent.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

struct GithubEvent: Decodable {
    let type: String
    let created_at: String
    let repo: Repo
    let payload: Payload
    
    struct Repo: Decodable {
        let name: String  // 예: "owner/repo"
    }
    
    struct Payload: Decodable {
        let size: Int?         // PushEvent인 경우, 커밋 수
        let commits: [PushCommit]?
    }
    
    struct PushCommit: Decodable {
        let message: String
    }
}
