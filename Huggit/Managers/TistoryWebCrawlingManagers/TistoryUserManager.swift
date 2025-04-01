//
//  TistoryUserManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/1/25.
//

import Foundation

final class TistoryUserManager {
    static let shared = TistoryUserManager()
    private init() {}
    
    /// 주어진 tistoryName에 해당하는 블로그가 존재하면 true, 아니면 false를 반환합니다.
    func isTistoryUser(username: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://\(username).tistory.com") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        // 웹 브라우저와 유사한 User-Agent 설정
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 네트워크 에러 발생 시 false 처리
            if let error = error {
                print("TistoryUserManager - Network error: \(error)")
                completion(false)
                return
            }
            
            // HTTP 응답 코드 체크 (200이 아니면 존재하지 않는 것으로 간주)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(false)
                return
            }
            
            // 데이터가 있고, HTML 문자열로 변환 가능한지 확인
            guard let data = data,
                  let html = String(data: data, encoding: .utf8) else {
                completion(false)
                return
            }
            
            // 제공해주신 HTML에서 에러를 나타내는 부분을 체크합니다.
            if html.contains("권한이 없거나 존재하지 않는") || html.contains("존재하지 않는") {
                completion(false)
            } else {
                completion(true)
            }
        }.resume()
    }
}
