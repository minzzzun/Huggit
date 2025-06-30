//
//  TistoryPostManager.swift
//  Huggit
//
//  Created by 김민준 on 3/24/25.
//

import Foundation
import SwiftSoup

enum TistoryCrawlerError: Error {
    case invalidURL
    case parsingError(Error)
    case networkError(Error)
    case dataConversionError
}

final class TistoryPostManager {
    static let shared = TistoryPostManager()
    private init() {}

    func fetchTistoryPosts(tistoryName: String, completion: @escaping ([Post]) -> Void) {
        fetchFromHTML(tistoryName: tistoryName) { posts in
            if posts.isEmpty {
                self.fetchFromRSS(tistoryName: tistoryName, completion: completion)
            } else {
                completion(posts)
            }
        }
    }

    private func fetchFromHTML(tistoryName: String, completion: @escaping ([Post]) -> Void) {
        guard let url = URL(string: "https://\(tistoryName).tistory.com") else {
            print("🚨 유효하지 않은 URL")
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("HTML 요청 실패: \(error)")
                completion([])
                return
            }

            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                print("HTML 데이터 변환 실패")
                completion([])
                return
            }

            do {
                let document = try SwiftSoup.parse(html)
                let elements = try document.select("section#list div.post")
                var posts: [Post] = []

                for element in elements.array() {
                    if posts.count >= 3 { break }

                    let title = try element.select("div.tit").text()
                    let summary = try element.select("div.summary").text()
                    let dateString = try element.select("time.date").text()
                    let link = try element.select("a.link").attr("href")
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
                print("HTML 파싱 오류: \(error)")
                completion([])
            }
        }.resume()
    }

    private func fetchFromRSS(tistoryName: String, completion: @escaping ([Post]) -> Void) {
        guard let url = URL(string: "https://\(tistoryName).tistory.com/rss") else {
            print("🚨 유효하지 않은 RSS URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("RSS 요청 실패: \(error?.localizedDescription ?? "알 수 없음")")
                completion([])
                return
            }

            let parser = XMLParser(data: data)
            let delegate = TistoryRSSParserDelegate(tistoryName: tistoryName) { posts in
                completion(posts)
            }
            parser.delegate = delegate
            parser.parse()
        }.resume()
    }

    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.date(from: dateString)
    }
}

final class TistoryRSSParserDelegate: NSObject, XMLParserDelegate {
    private let tistoryName: String
    private let completion: ([Post]) -> Void

    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentSummary = ""
    private var currentDate = ""

    private var posts: [Post] = []
    private var isItem = false

    init(tistoryName: String, completion: @escaping ([Post]) -> Void) {
        self.tistoryName = tistoryName
        self.completion = completion
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            isItem = true
            currentTitle = ""
            currentLink = ""
            currentSummary = ""
            currentDate = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard isItem else { return }

        switch currentElement {
        case "title": currentTitle += string
        case "link": currentLink += string
        case "description": currentSummary += string
        case "pubDate": currentDate += string
        default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "item" {
            isItem = false

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"

            let date = formatter.date(from: currentDate) ?? Date()

            let post = Post(
                type: .tistory,
                date: date,
                link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                summary: currentSummary.trimmingCharacters(in: .whitespacesAndNewlines)
            )

            posts.append(post)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        completion(posts)
    }
}
