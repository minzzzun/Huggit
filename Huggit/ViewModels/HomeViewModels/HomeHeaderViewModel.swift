//
//  HomeHeaderViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import SwiftUI
import Combine

final class HomeHeaderViewModel: ObservableObject {
    
    // MARK: 뷰에서 사용되는 값
    @Published var selectedMonth: Int = 3
    @Published var commitsInMonth: Int = 0
    @Published var commitStreak: Int = 0
    
    // MARK: 가공되어야 하는 데이터
    @Published var contributionDetailsByDay: [Int: [ContributionDetail]] = [:] {
        didSet {
            updateCommitsInMonth()
            calculateCommitStreak()
        }
    }
    
    private var today: Int {
        Calendar.current.component(.day, from: Date())
    }
    
    private func commitCount(for day: Int) -> Int {
        return contributionDetailsByDay[day]?.reduce(0, { $0 + $1.messages.count }) ?? 0
    }
    
    /// 전체 커밋 수 업데이트
    private func updateCommitsInMonth() {
        let total = contributionDetailsByDay.reduce(0) { result, pair in
            let (_, details) = pair
            return result + details.reduce(0, { $0 + $1.messages.count })
        }
        self.commitsInMonth = total
    }
    
    /// 이번 달의 연속된 커밋 일 수 계산
    private func calculateCommitStreak() {
        let currentDay = today
        var streak = 0
        // 오늘부터 1일까지 반복
        for day in stride(from: currentDay, through: 1, by: -1) {
            if commitCount(for: day) > 0 {
                streak += 1
            } else {
                break
            }
        }
        self.commitStreak = streak
    }
    
    func stampName(for stampOrder: Int) -> String {
        // 원래 로직:
        // stampOrder 1: 오늘 - 3번째 날의 커밋 상태,
        // stampOrder 2: 오늘 - 2번째,
        // stampOrder 3: 오늘 - 1번째
        let targetDay: Int
        switch stampOrder {
        case 1:
            targetDay = today - 2
        case 2:
            targetDay = today - 1
        case 3:
            targetDay = today
        default:
            return ""
        }
        if targetDay >= 1, commitCount(for: targetDay) > 0 {
            return stampOrder == 1 ? "stamp_1st_enable" : "stamp_2nd_3rd_enable"
        } else {
            return stampOrder == 1 ? "stamp_1st_disable" : "stamp_2nd_3rd_disable"
        }
    }
    
    var tooltipText: String {
        let todayCount = commitCount(for: today)
        if todayCount == 0 {
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
