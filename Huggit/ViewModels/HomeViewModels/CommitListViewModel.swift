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
    private var tempPostsList: [Post] = []
    
    var sortedCommitList: [Post] {
        commitList.sorted { $0.date < $1.date }
    }
    
    init() {
        let group = DispatchGroup()
        
        group.enter()
        fetchVelogPosts(completion: {
            group.leave()
        })
        
        group.enter()
        fetchTistoryPosts(completion: {
            group.leave()
        })
        
        group.notify(queue: .main) {
            self.filterPostsMatchingCommitMessages()
        }
    }
    
    func fetchVelogPosts(completion: @escaping () -> Void) {
        let velogUsername = UserInfo.velogName
        guard !velogUsername.isEmpty else {
            completion()
            return
        }
        
        VelogPostManager.shared.fetchVelogPosts(username: velogUsername) { [weak self] posts in
            DispatchQueue.main.async {
                // 필터링 전에는 임시 변수에 저장
                self?.tempPostsList += posts
                completion()
            }
        }
    }
    
    func fetchTistoryPosts(completion: @escaping () -> Void) {
        let tistoryName = UserInfo.tistoryName
        guard !tistoryName.isEmpty else {
            completion()
            return
        }
        
        TistoryPostManager.shared.fetchTistoryPosts(tistoryName: tistoryName) { [weak self] posts in
            DispatchQueue.main.async {
                // 필터링 전에는 임시 변수에 저장
                self?.tempPostsList += posts
                completion()
            }
        }
    }
    
    func filterPostsMatchingCommitMessages() {
        guard let earliestPost = tempPostsList.sorted(by: { $0.date < $1.date }).first else { return }
        let calendar = Calendar.current
        
        // 가장 오래된 post 날짜보다 하루 전을 시작 날짜로 설정
        guard let fetchStartDate = calendar.date(byAdding: .day, value: -1, to: earliestPost.date) else { return }
        let today = Date()
        
        var commitMessages: [String] = []
        let group = DispatchGroup()
        
        var currentDate = fetchStartDate
        while currentDate <= today {
            group.enter()
            GithubCommitFetchManager.shared.fetchContributionDetails(for: UserInfo.gitLogin, on: currentDate) { result in
                switch result {
                case .success(let details):
                    for detail in details {
                        if detail.repositoryName == UserInfo.repoName {
                            commitMessages.append(contentsOf: detail.messages)
                        }
                    }
                case .failure(let error):
                    print("Error fetching commit details for \(currentDate): \(error)")
                }
                group.leave()
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        group.notify(queue: .main) {
            let commitMessageSet = Set(commitMessages)
            print("Before filtering, tempPostsList count: \(self.tempPostsList.count)")
            print("Commit message set: \(commitMessageSet)")
            
            // 필터링 후에 최종 결과를 commitList에 할당
            self.commitList = self.tempPostsList.filter { post in
                let typeString = (post.type == .tistory) ? "Tistory" : "Velog"
                let formattedTitle = ("[\(typeString)] \(post.title)")
                return !commitMessageSet.contains(formattedTitle)
            }
            print("After filtering, commitList count: \(self.commitList.count)")
        }
    }
}
