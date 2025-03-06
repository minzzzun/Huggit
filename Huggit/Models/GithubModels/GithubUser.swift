//
//  GithubUser.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

struct GithubUser: Decodable, Equatable {
    let login: String
    let id: Int?
    let name: String?
    let avatar_url: String?
}
