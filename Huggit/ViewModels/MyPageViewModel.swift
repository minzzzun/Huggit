//
//  MyPageViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/24/25.
//

import Foundation
import Combine

class MyPageViewModel: ObservableObject {
    @Published var githubName: String = "미등록"
    @Published var tistoryName: String = UserDefaults.standard.string(forKey: "tistoryName") ?? "미등록"
    @Published var velogName: String = UserDefaults.standard.string(forKey: "velogName") ?? "미등록"
    
    @Published var currentYear: Int = Calendar.current.component(.year, from: Date())
    @Published var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    @Published var totalCommitsThisMonth: Int = 0
    
    
    
    init() {
        fetchGithubUser()
    }
    
    func fetchGithubUser() {
        GithubUserManager.shared.fetchUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.githubName = user.login
                    // githubName이 업데이트된 후에 총 커밋 수를 가져옵니다.
                    self?.fetchTotalCommits()
                case .failure(let error):
                    print("Error fetching GitHub user: \(error)")
                }
            }
        }
    }
    
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
        UserDefaults.standard.removeObject(forKey: "appleId")
        print("로그아웃 완료: appleId가 삭제되었습니다.")
        completion()
    }
}
