//
//  VelogUserResponse.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/1/25.
//

import Foundation

struct VelogUserResponse: Decodable {
    let data: VelogUserData
}

struct VelogUserData: Decodable {
    let user: VelogUser?
}

struct VelogUser: Decodable {
    let id: String
    let username: String
}
