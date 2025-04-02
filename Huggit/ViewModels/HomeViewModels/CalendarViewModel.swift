import SwiftUI
import Combine

enum CurrentGrass {
    case allGrass
    case codeGrass
    case blogGrass
}

final class CalendarViewModel: ObservableObject {
    
    // MARK: 뷰에서 사용되는 값
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
    
    // MARK: 가공되어야 하는 데이터
    @Published var contributionDetailsByDay: [Int: [ContributionDetail]] = [:] {
        didSet {
            updateAllCommitCount()
            updateBlogCommitCount()
        }
    }
    
    // MARK: UI 관련
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
    
    // MARK: 데이터 관려
    private func updateAllCommitCount() {
        let totalDays = daysInMonth.count
        var newCounts: [Int] = []
        for day in 1...totalDays {
            let count = contributionDetailsByDay[day]?.reduce(0, { $0 + $1.messages.count }) ?? 0
            newCounts.append(count)
        }
        self.dayAllCommitCount = newCounts
    }

    private func updateBlogCommitCount() {
        let totalDays = daysInMonth.count
        var newCounts: [Int] = []
        let blogRepoName = UserInfo.repoName
        for day in 1...totalDays {
            let count = contributionDetailsByDay[day]?.filter { $0.repositoryName == blogRepoName }
                .reduce(0, { $0 + $1.messages.count }) ?? 0
            newCounts.append(count)
        }
        self.dayBlogCommitCount = newCounts
    }
}
