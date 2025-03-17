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

struct GithubErrorResponse: Decodable, Error {
    let message: String
    let documentation_url: String
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
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidURL))
                return
            }
            
            // HTTP 상태 코드 체크 (200~299이면 성공)
            if !(200...299).contains(httpResponse.statusCode) {
                // 에러 응답 디코딩 시도
                if let githubError = try? JSONDecoder().decode(GithubErrorResponse.self, from: data) {
                    completion(.failure(.networkError(NSError(domain: githubError.message, code: httpResponse.statusCode, userInfo: nil))))
                } else {
                    completion(.failure(.networkError(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil))))
                }
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
