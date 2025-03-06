//
//  HomeHeaderViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import SwiftUI
import Combine

final class HomeHeaderViewModel: ObservableObject {
    @Published var dayAllCommitCount: [Int]
    @Published var historicalDayAllCommitCounts: [[Int]]
    
    // 연속 커밋일
    @Published var commitStreak: Int = 0
    
    init(dayAllCommitCount: [Int] = [], historicalDayAllCommitCounts: [[Int]] = []) {
        self.dayAllCommitCount = dayAllCommitCount
        self.historicalDayAllCommitCounts = historicalDayAllCommitCounts
    }
    
    private var today: Int {
        Calendar.current.component(.day, from: Date())
    }
    
    // 현재 달의 streak (오늘부터 1일까지 연속된 커밋)
    private var currentMonthStreak: Int {
        var streak = 0
        for day in stride(from: today - 1, through: 0, by: -1) {
            if day < dayAllCommitCount.count, dayAllCommitCount[day] > 0 {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }
    
    // 이전 달들에서 streak이 이어진 날 수 (역순으로 계산)
    private var historicalStreak: Int {
        var streak = 0
        for monthCommits in historicalDayAllCommitCounts {
            if monthCommits.isEmpty { continue }
            for commit in monthCommits.reversed() {
                if commit > 0 {
                    streak += 1
                } else {
                    return streak
                }
            }
        }
        return streak
    }
    
    // 오늘부터 연속 streak 계산 (항상 이전 달까지 포함)
    func calculateCommitStreak() {
        // 만약 현재 달 전체(1일부터 오늘까지)가 연속이면, 이전 달 streak도 합산
        if currentMonthStreak == today {
            commitStreak = currentMonthStreak + historicalStreak
        } else {
            commitStreak = currentMonthStreak
        }
    }
    
    // 연속 커밋일 계산
    func fetchHistoricalStreakContributions(for username: String, completion: @escaping () -> Void) {
        let calendar = Calendar.current
        var streakData: [[Int]] = []
        let dispatchGroup = DispatchGroup()
        
        // 재귀 호출 함수: 특정 달의 데이터 가져오기
        func recursiveFetch(for date: Date) {
            guard let range = calendar.range(of: .day, in: .month, for: date) else { return }
            let totalDays = range.count
            let comps = calendar.dateComponents([.year, .month], from: date)
            guard let fromDate = calendar.date(from: comps),
                  let toDate = calendar.date(byAdding: .day, value: totalDays, to: fromDate) else { return }
            
            dispatchGroup.enter()
            GithubCommitFetchManager.shared.fetchContributionCountsInPeriod(username: username, from: fromDate, to: toDate) { result in
                switch result {
                case .success(let countsByDate):
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    var monthlyCounts: [Int] = []
                    var compsForMonth = comps
                    for day in 1...totalDays {
                        compsForMonth.day = day
                        if let dayDate = calendar.date(from: compsForMonth) {
                            let key = dateFormatter.string(from: dayDate)
                            monthlyCounts.append(countsByDate[key] ?? 0)
                        }
                    }
                    streakData.append(monthlyCounts)
                    
                    // streak 유지 여부: 해당 달의 모든 날에 커밋이 있었으면
                    let isContinuous = monthlyCounts.allSatisfy { $0 > 0 }
                    dispatchGroup.leave()
                    
                    if isContinuous {
                        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: date) {
                            recursiveFetch(for: previousMonth)
                        }
                    }
                case .failure(let error):
                    print("Error fetching historical data for \(date): \(error)")
                    streakData.append(Array(repeating: 0, count: totalDays))
                    dispatchGroup.leave()
                }
            }
        }
        
        recursiveFetch(for: Date())
        
        dispatchGroup.notify(queue: .main) {
            self.historicalDayAllCommitCounts = streakData
            completion()
        }
    }
    
    // 기존의 stampName, tooltipText 등은 그대로 둡니다.
    func stampName(for stampOrder: Int) -> String {
        switch stampOrder {
        case 1:
            return commitStreak >= 3 ? "stamp_1st_enable" : "stamp_1st_disable"
        case 2:
            return commitStreak >= 2 ? "stamp_2nd_3rd_enable" : "stamp_2nd_3rd_disable"
        case 3:
            return commitStreak >= 1 ? "stamp_2nd_3rd_enable" : "stamp_2nd_3rd_disable"
        default:
            return ""
        }
    }
    
    var tooltipText: String {
        if today - 1 >= dayAllCommitCount.count || dayAllCommitCount[today - 1] == 0 {
            return "오늘의 커밋 도장을 찍어볼까요?"
        } else {
            if commitStreak == 1 {
                return "오늘의 commit 완료!"
            } else if commitStreak >= 2 {
                return "\(commitStreak)일 연속 commit 실천중!"
            } else {
                return ""
            }
        }
    }
}
