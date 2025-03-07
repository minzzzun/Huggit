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
    
    var soredCommitList: [Post] {
        commitList.sorted { $0.date < $1.date}
    }
    
    init() {
        // 초기화 시 mock 데이터를 생성하여 할당
        self.commitList = Self.generateMockPosts()
    }
    
    // mock 데이터를 생성하는 static 함수 예시
    static func generateMockPosts() -> [Post] {
        let now = Date()
        return [
            Post(type: .tistory, date: now, link: "https://example.com/1", title: "첫번째 커밋", summary: "첫번째 커밋 요약 내용입니다."),
            Post(type: .velog, date: now.addingTimeInterval(-3600), link: "https://example.com/2", title: "두번째 커밋", summary: "두번째 커밋 요약 내용입니다."),
            Post(type: .tistory, date: now.addingTimeInterval(-7200), link: "https://example.com/3", title: "세번째 커밋", summary: "세번째 커밋 요약 내용입니다.")
        ]
    }
}
