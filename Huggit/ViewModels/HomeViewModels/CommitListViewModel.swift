//
//  CommitListViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/7/25.
//

import SwiftUI
import Combine

final class CommitListViewModel: ObservableObject {
    @Published var commitList: [Post] = []
    
    var sortedCommitList: [Post] {
        commitList.sorted { $0.date < $1.date }
    }
    
    init() {
        self.commitList = Self.generateMockPosts()
        fetchVelogPosts()
        fetchTistoryPosts()
    }
    
    static func generateMockPosts() -> [Post] {
        return [
            Post(type: .tistory, date: Date().addingTimeInterval(Double.random(in: -100000...0)),
                 link: "https://example.com/1", title: "첫번째 커밋", summary: "첫번째 커밋 요약 내용입니다."),
            Post(type: .velog, date: Date().addingTimeInterval(Double.random(in: -100000...0)),
                 link: "https://example.com/2", title: "두번째 커밋", summary: "두번째 커밋 요약 내용입니다."),
            Post(type: .tistory, date: Date().addingTimeInterval(Double.random(in: -100000...0)),
                 link: "https://example.com/3", title: "세번째 커밋", summary: "세번째 커밋 요약 내용입니다.")
        ]
    }
    
    func fetchVelogPosts() {
        let velogUsername = UserDefaults.standard.string(forKey: "velogName") ?? ""
        guard !velogUsername.isEmpty else { return }
        
        VelogPostManager.shared.fetchVelogPosts(username: velogUsername) { [weak self] posts in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.commitList = self.commitList + posts // ✅ 새로운 배열을 할당하여 UI 변경 감지
            }
        }
    }
    
    func fetchTistoryPosts() {
           let tistoryName = UserDefaults.standard.string(forKey: "tistoryName") ?? ""
           guard !tistoryName.isEmpty else { return }
           
        TistoryPostManager.shared.fetchTistoryPosts(tistoryName: tistoryName) { [weak self] posts in
            DispatchQueue.main.async{
                guard let self = self else { return }
                self.commitList = self.commitList + posts
            }
        }
       }
    
    
    
    
    
}
