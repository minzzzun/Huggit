//
//  GithubRestManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum GithubAPIError: Error {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
}

final class GithubRestManager {
    static let shared = GithubRestManager()
    private init() {}
    
    private let baseURL = "https://api.github.com"
    private var token: String {
            return UserDefaults.standard.string(forKey: "githubAccessToken") ?? ""
        }
    private let session = URLSession.shared
    
    func request<T: Decodable>(endpoint: String,
                               method: HTTPMethod = .GET,
                               parameters: [String: Any]? = nil,
                               completion: @escaping (Result<T, GithubAPIError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completion(.failure(.networkError(error)))
                return
            }
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
