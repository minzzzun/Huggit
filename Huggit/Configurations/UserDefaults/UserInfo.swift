//
//  UserInfo.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/30/25.
//

import SwiftUI

struct UserInfo {
    static let defaultRepoName = "HUGGIT_TECHBLOG"
    
    @UserDefault(key: UserDefaultsKeys.appleId.rawValue, defaultValue: "")
    static var appleId: String
    
    @UserDefault(key: UserDefaultsKeys.gitLogin.rawValue, defaultValue: "")
    static var gitLogin: String
    
    @UserDefault(key: UserDefaultsKeys.gitName.rawValue, defaultValue: "")
    static var gitName: String
    
    @UserDefault(key: UserDefaultsKeys.gitEmail.rawValue, defaultValue: "")
    static var gitEmail: String
    
    @UserDefault(key: UserDefaultsKeys.repoName.rawValue, defaultValue: "")
    static var repoName: String
    
    @UserDefault(key: UserDefaultsKeys.githubAccessToken.rawValue, defaultValue: "")
    static var githubAccessToken: String
    
    @UserDefault(key: UserDefaultsKeys.tistoryName.rawValue, defaultValue: "")
    static var tistoryName: String
    
    @UserDefault(key: UserDefaultsKeys.velogName.rawValue, defaultValue: "")
    static var velogName: String
}

