//
//  HomeHeaderViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import SwiftUI
import Combine

final class HomeHeaderViewModel: ObservableObject {
    @Published var commitsInMonth: Int = 0
    @Published var commitStreak: Int = 0
    @Published var dayAllCommitCount: [Int] {
        didSet {
            updateCommitsInMonth()
            calculateCommitStreak()
        }
    }

    init(dayAllCommitCount: [Int] = []) {
        self.dayAllCommitCount = dayAllCommitCount
        self.updateCommitsInMonth()
        self.calculateCommitStreak()
    }
    
    private var today: Int {
        Calendar.current.component(.day, from: Date())
    }
    
    /// 이번 달 전체 커밋 수 업데이트
        private func updateCommitsInMonth() {
            self.commitsInMonth = dayAllCommitCount.reduce(0, +)
        }

        /// 이번 달의 연속된 커밋 일 수 계산
        private func calculateCommitStreak() {
            let today = Calendar.current.component(.day, from: Date())
            commitStreak = 0
            
            for day in stride(from: today - 1, through: 0, by: -1) {
                if day < dayAllCommitCount.count, dayAllCommitCount[day] > 0 {
                    commitStreak += 1
                } else {
                    break
                }
            }
        }
    
    func stampName(for stampOrder: Int) -> String {
        switch stampOrder {
        case 1:
            let index = today - 3
            if index >= 0, index < dayAllCommitCount.count, dayAllCommitCount[index] > 0 {
                return "stamp_1st_enable"
            } else {
                return "stamp_1st_disable"
            }
        case 2:
            let index = today - 2
            if index >= 0, index < dayAllCommitCount.count, dayAllCommitCount[index] > 0 {
                return "stamp_2nd_3rd_enable"
            } else {
                return "stamp_2nd_3rd_disable"
            }
        case 3:
            let index = today - 1
            if index < dayAllCommitCount.count, dayAllCommitCount[index] > 0 {
                return "stamp_2nd_3rd_enable"
            } else {
                return "stamp_2nd_3rd_disable"
            }
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
