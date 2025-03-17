//
//  GithugCommitPushRequestModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/17/25.
//

import Foundation

struct CommitPushRequestModel: Encodable {
    let message: String
    let committer: Committer
    let content: String
    let sha: String? // 파일 업데이트 시 필요한 기존 파일의 SHA
}

struct Committer: Encodable {
    let name: String
    let email: String
}
