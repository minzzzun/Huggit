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
    
    // 초기화 인자를 추가하여 HomeViewModel의 CalendarViewModel 데이터를 전달받습니다.
    init(dayAllCommitCount: [Int] = [], historicalDayAllCommitCounts: [[Int]] = []) {
        self.dayAllCommitCount = dayAllCommitCount
        self.historicalDayAllCommitCounts = historicalDayAllCommitCounts
    }
    
    private var today: Int {
        Calendar.current.component(.day, from: Date())
    }
    
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
    
    var commitStreak: Int {
        if today == 1 {
            return currentMonthStreak + historicalStreak
        } else {
            return currentMonthStreak
        }
    }
    
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
