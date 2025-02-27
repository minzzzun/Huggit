//
//  CalenderViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI
import Combine

enum CurrentGrass {
    case allGrass
    case codeGrass
    case blogGrass
}

final class CalendarViewModel: ObservableObject {
    // 현재 년
    @Published var currentYear: Int = Calendar.current.component(.year, from: Date())
    // 현재 달
    @Published var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    // 현재 년/달 변경 모달
    @Published var selectMonth = false
    
    // 현재 잔디
    @Published var currentGrass: CurrentGrass = .allGrass
    
    @Published var dayAllCommitCount: [Int] = []
    @Published var dayBlogCommitCount: [Int] = []
    
    // 요일
    let daysOfTheWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    // 현재 달의 일자 (1 ~ 말일)
    var daysInMonth: [Int] {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        guard let date = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        return Array(range)
    }
    
    // 현재 달의 1일이 속한 요일 (일요일 = 1, 월요일 = 2, ...)
    var firstWeekday: Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: currentYear, month: currentMonth, day: 1)
        guard let firstDay = calendar.date(from: dateComponents) else { return 1 }
        return calendar.component(.weekday, from: firstDay)
    }
    
    // 첫 주에 빈 칸을 포함해서 전체 달력에 들어갈 셀 배열 (nil이면 빈 셀)
    var daysInMonthWithPadding: [Int?] {
        // offset: 첫 날 전에 들어갈 빈 셀의 수 (예: firstWeekday가 4이면 앞에 3개)
        let offset = firstWeekday - 1
        return Array(repeating: nil, count: offset) + daysInMonth.map { Optional($0) }
    }
    
    // commit 개수 비율 계산 Helper 함수
    var maxCodeCommitCount: Int {
        let codeCommits = zip(dayAllCommitCount, dayBlogCommitCount).map { $0 - $1 }
        return codeCommits.max() ?? 0
    }
    
    var maxBlogCommitCount: Int {
        return dayBlogCommitCount.max() ?? 0
    }
    
    // 테스트용 MockData 관련 
    init() {
        generateMockData()
    }
    
    // 현재 달의 일 수에 맞춰 랜덤 커밋 수를 생성하는 함수
    func generateMockData() {
        let days = daysInMonth.count
        // 전체 커밋 수: 0 ~ 10 사이의 랜덤 값
        dayAllCommitCount = (0..<days).map { _ in Int.random(in: 0...10) }
        // 블로그 커밋 수: 전체 커밋 수 이하의 랜덤 값
        dayBlogCommitCount = dayAllCommitCount.map { total in Int.random(in: 0...total) }
    }
}

