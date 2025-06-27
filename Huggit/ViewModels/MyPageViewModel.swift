//
//  MyPageViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/24/25.
//

import Foundation
import Combine

class MyPageViewModel: ObservableObject {
    @Published var githubName: String = {
        return UserInfo.appleId.isEmpty
            ? "Guest"
            : (UserInfo.gitName.isEmpty ? "아직 등록되지 않았어요" : UserInfo.gitName)
    }()

    @Published var tistoryName: String = {
        return UserInfo.appleId.isEmpty
            ? "Guest"
            : (UserInfo.tistoryName.isEmpty ? "아직 등록되지 않았어요" : UserInfo.tistoryName)
    }()

    @Published var velogName: String = {
        return UserInfo.appleId.isEmpty
            ? "Guest"
            : (UserInfo.velogName.isEmpty ? "아직 등록되지 않았어요" : UserInfo.velogName)
    }()
    
    @Published var currentYear: Int = Calendar.current.component(.year, from: Date())
    @Published var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    @Published var totalCommitsThisMonth: Int = 0
    
    init() {
        fetchTotalCommits()
    }
    
    func fetchTotalCommits() {
        let calendar = Calendar.current
        var comps = DateComponents(year: currentYear, month: currentMonth, day: 1)
        guard let startDate = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: startDate) else { return }
        let totalDays = range.count
        comps.day = totalDays
        guard let rawEndDate = calendar.date(from: comps) else { return }
            // endDate를 23:59:59로 변경하여 해당 날짜의 마지막 순간까지 포함되도록 합니다.
            guard let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: rawEndDate) else { return }
        
        GithubCommitFetchManager.shared.fetchContributionCountsInPeriod(username: UserInfo.gitLogin, from: startDate, to: endDate) { [weak self] result in
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
    
    /// 로그아웃 기능
    func logout(completion: @escaping () -> Void) {
        AppleAuthManager.shared.logout {
            completion()
        }
    }
    
    /// 회원탈퇴 기능
    func deleteAccount(completion: @escaping () -> Void) {
        AppleAuthManager.shared.deleteAccount {
            completion()
        }
    }
    
 
}
