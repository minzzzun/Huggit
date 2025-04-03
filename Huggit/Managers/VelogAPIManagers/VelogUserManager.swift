//
//  VelogUserManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/1/25.
//

import Foundation

final class VelogUserManager {
    static let shared = VelogUserManager()
    private init() {}
    
    func isVelogUser(username: String, completion: @escaping (Bool) -> Void) {
        let query = VelogGraphQLQueries.fetchUserQuery(username: username)
        VelogGraphQLManager.shared.request(query: query) { (result: Result<VelogUserResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // user가 nil이 아니라면 해당 username의 Velog 사용자가 존재하는 것으로 간주
                    if let user = response.data.user {
                        print("Velog user found: \(user.username)")
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure(let error):
                    print("Error fetching Velog user: \(error)")
                    completion(false)
                }
            }
        }
    }
}
