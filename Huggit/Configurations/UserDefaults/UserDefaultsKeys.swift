//
//  UserDefaultsKeys.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/30/25.
//

import Foundation

// MARK: - UserDefaults 키 모음
enum UserDefaultsKeys: String {
    case appleId = "appleId"
    case gitLogin = "gitLogin" // 고유 로그인 이름
    case gitName = "gitName" // Full Name
    case gitEmail = "gitEmail"
    case repoName = "repoName"
    case githubAccessToken = "githubAccessToken"
    case tistoryName = "tistoryName"
    case velogName = "velogName"
}
