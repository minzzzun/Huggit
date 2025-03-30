//
//  MyPageViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/24/25.
//

import Foundation
import Combine

class MyPageViewModel: ObservableObject {
    @Published var githubName: String = UserInfo.gitName.isEmpty ? "미등록" : UserInfo.gitName
    @Published var tistoryName: String = UserInfo.tistoryName.isEmpty ? "미등록" : UserInfo.tistoryName
    @Published var velogName: String = UserInfo.velogName.isEmpty ? "미등록" : UserInfo.velogName
    
    @Published var currentYear: Int = Calendar.current.component(.year, from: Date())
    @Published var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    @Published var totalCommitsThisMonth: Int = 0
    
    
    
    init() {}
    
    func fetchTotalCommits() {
        guard githubName != "미등록" else { return }
        
        let calendar = Calendar.current
        var comps = DateComponents(year: currentYear, month: currentMonth, day: 1)
        guard let startDate = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: startDate) else { return }
        comps.day = range.count
        guard let endDate = calendar.date(from: comps) else { return }
        
        GithubCommitFetchManager.shared.fetchContributionCountsInPeriod(username: githubName, from: startDate, to: endDate) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countsByDate):
                    let total = countsByDate.values.reduce(0, +)
                    self?.totalCommitsThisMonth = total
                case .failure(let error):
                    print("Error fetching total commits: \(error)")
                }
            }
        }
    }
    
    func logout(completion: @escaping () -> Void) {
        UserInfo.appleId = ""
        print("로그아웃 완료: appleId가 삭제되었습니다.")
        completion()
    }
}
