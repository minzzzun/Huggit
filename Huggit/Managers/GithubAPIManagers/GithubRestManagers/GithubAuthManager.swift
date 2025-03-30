//
//  GithubAuthManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/30/25.
//

import Foundation
import UIKit

enum GithubAuthError: Error {
    case missingClientID
    case missingClientSecret
    case networkError(Error)
    case invalidResponse
    case tokenNotFound
    case jsonParsingError(Error)
}

final class GithubAuthManager {
    static let shared = GithubAuthManager()
    private init() {}
    
    // OAuth 요청 URL을 구성하고, 열도록 합니다.
    func requestCode() {
        // 스코프는 공백으로 구분해야 합니다.
        let scope = "repo user user:email"
        guard let clientId = GitHubConfig.client_id else {
            print("❌ client_id가 없습니다.")
            return
        }
        
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientId)&scope=\(scope)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // 받은 code로 access token을 요청하는 메서드
    func requestAccessToken(code: String, completion: @escaping (Result<String, GithubAuthError>) -> Void) {
        guard let clientId = GitHubConfig.client_id,
              let clientSecret = GitHubConfig.client_secret else {
            completion(.failure(.missingClientID))
            return
        }
        
        guard let url = URL(string: "https://github.com/login/oauth/access_token") else {
            completion(.failure(.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let token = json["access_token"] as? String {
                completion(.success(token))
            } else {
                completion(.failure(.tokenNotFound))
            }
        }.resume()
    }
}
