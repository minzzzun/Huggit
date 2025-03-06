//
//  GithubUserManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

final class GithubUserManager {
    static let shared = GithubUserManager()
    private init() {}
    
    func fetchUser(completion: @escaping (Result<GithubUser, GithubAPIError>) -> Void) {
        let endpoint = "/user"
        GithubRestManager.shared.request(endpoint: endpoint,
                                           method: .GET,
                                           parameters: nil,
                                           completion: completion)
    }
}
