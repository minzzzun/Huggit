//
//  GithubUserEmail.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/30/25.
//

struct GithubUserEmail: Decodable {
    let email: String
    let primary: Bool
    let verified: Bool
    let visibility: String?
}
