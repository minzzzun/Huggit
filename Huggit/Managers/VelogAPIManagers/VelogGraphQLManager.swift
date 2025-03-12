//
//  VelogGraphQLManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/11/25.
//

import Foundation

final class VelogGraphQLManager {
    static let shared = VelogGraphQLManager()
    private init() {}
    
    private let graphQLURL = "https://v2.velog.io/graphql"
    private let session = URLSession.shared
    
    func request<T: Decodable>(query: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: graphQLURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: query, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                return
            }
            
            // ✅ API 응답 로그 추가 (Raw JSON 출력)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📢 Raw API Response:\n\(jsonString)") // <--- 추가된 로그
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("❌ JSON Decoding Error: \(error)")  // <--- 디코딩 에러 확인
                completion(.failure(error))
            }
        }.resume()
    }
}
