//
//  TistoryPostManager.swift
//  Huggit
//
//  Created by 김민준 on 3/24/25.
//

import Foundation
import SwiftSoup

enum TistoryCrawlerError: Error {
    case invalidURL        // URL이 유효하지 않을 때
    case parsingError(Error)   // HTML 파싱 중 오류 발생
    case networkError(Error)   // 네트워크 통신 중 오류
    case dataConversionError   // 데이터 변환 실패
}

final class TistoryPostManager {
    static let shared = TistoryPostManager()
    private init(){}
    
    func fetchTistoryPosts(tistoryName: String, completion: @escaping([Post]) -> Void){
        guard let url = URL(string: "https://\(tistoryName).tistory.com") else {
            print("🚨유효하지 않은 URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("에러 발생: \(error)")
                completion([])
                return
            }
            
            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                print("데이터 변환 실패")
                completion([])
                return
            }
            
            do {
                let document = try SwiftSoup.parse(html)
                let articles = try document.select("article.article-type-common")
                var posts: [Post] = []
                
                for article in articles.array() {
                    // 제목 추출
                    let title = try article.select("strong.title").text()
                    // 요약 추출
                    let summary = try article.select("p.summary").text()
                    // 날짜 추출
                    let dateString = try article.select("span.date").text()
                    // 링크 추출
                    let link = try article.select("a.link-article").attr("href")
                    let fullLink = "https://\(tistoryName).tistory.com\(link)"
                    
                    let date = self.parseDate(dateString) ?? Date()
                    
                    let post = Post(
                        type: .tistory,
                        date: date,
                        link: fullLink,
                        title: title,
                        summary: summary
                    )
                    posts.append(post)
                }
                completion(posts)
                
            } catch {
                print("파싱 중 오류 발생: \(error)")
                completion([])
            }
        }.resume()
    }
    
    func parseDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd" // Tistory 날짜 형식에 맞게 수정
        return dateFormatter.date(from: dateString)
    }
}
