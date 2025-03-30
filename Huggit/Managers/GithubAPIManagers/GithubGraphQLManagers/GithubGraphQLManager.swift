//
//  GithubGraphQLManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

final class GithubGraphQLManager {
    static let shared = GithubGraphQLManager()
    private init() {}
    
    private let graphQLURL = "https://api.github.com/graphql"
    private var token: String {
        return UserInfo.githubAccessToken
    }
    private let session = URLSession.shared
    
    func request<T: Decodable>(query: String,
                               completion: @escaping (Result<T, GithubAPIError>) -> Void) {
        guard let url = URL(string: graphQLURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = ["query": query]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(.networkError(error)))
            return
        }
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidURL))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
