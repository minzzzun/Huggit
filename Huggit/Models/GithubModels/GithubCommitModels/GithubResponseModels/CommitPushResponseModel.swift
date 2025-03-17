//
//  CommitPushResponseModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/17/25.
//

import Foundation

struct CommitPushResponseModel: Decodable {
    let content: FileContent
    let commit: CommitDetails
}

struct FileContent: Decodable {
    let name: String
    let path: String
    let sha: String
    let size: Int
    let url: String
    let html_url: String
    let git_url: String
    let download_url: String
    let type: String
}

struct CommitDetails: Decodable {
    let sha: String
    let message: String
}
