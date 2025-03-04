import SwiftUI
import Combine

enum CurrentGrass {
    case allGrass
    case codeGrass
    case blogGrass
}

final class CalendarViewModel: ObservableObject {
    // 현재 년/월
    @Published var currentYear: Int = Calendar.current.component(.year, from: Date())
    @Published var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    // 년/월 변경 모달 여부
    @Published var selectMonth = false
    
    // 잔디 타입
    @Published var currentGrass: CurrentGrass = .allGrass
    
    // 현재 달의 일자별 커밋 데이터 (예: 1일~말일)
    @Published var dayAllCommitCount: [Int] = []
    @Published var dayBlogCommitCount: [Int] = []
    
    // 과거 달들의 커밋 데이터 (최근 달부터 과거 순서로)
    // 각 배열은 해당 달의 일자별 커밋 수
    @Published var historicalDayAllCommitCounts: [[Int]]? = nil
    
    // 요일 배열
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
    
    // 현재 달 1일의 요일 (일요일 = 1, 월요일 = 2, ...)
    var firstWeekday: Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: currentYear, month: currentMonth, day: 1)
        guard let firstDay = calendar.date(from: dateComponents) else { return 1 }
        return calendar.component(.weekday, from: firstDay)
    }
    
    // 달력에 들어갈 셀 배열 (빈 칸은 nil)
    var daysInMonthWithPadding: [Int?] {
        let offset = firstWeekday - 1
        return Array(repeating: nil, count: offset) + daysInMonth.map { Optional($0) }
    }
    
    // commit 개수 계산 헬퍼들 
    var maxCodeCommitCount: Int {
        let codeCommits = zip(dayAllCommitCount, dayBlogCommitCount).map { $0 - $1 }
        return codeCommits.max() ?? 0
    }
    
    var maxBlogCommitCount: Int {
        return dayBlogCommitCount.max() ?? 0
    }
    
    // 테스트용 MockData 생성
    init() {
        generateMockData()
        // 예시로 과거 2달의 데이터를 생성
        historicalDayAllCommitCounts = [
            (0..<28).map { _ in Int.random(in: 0...1) },
            (0..<31).map { _ in Int.random(in: 0...1) }
        ]
    }
    
    func generateMockData() {
        let days = daysInMonth.count
        dayAllCommitCount = (0..<days).map { _ in Int.random(in: 0...10) }
        dayBlogCommitCount = dayAllCommitCount.map { total in Int.random(in: 0...total) }
    }
}
