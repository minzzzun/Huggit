import SwiftUI
import Combine

enum CurrentGrass {
    case allGrass
    case codeGrass
    case blogGrass
}

final class CalendarViewModel: ObservableObject {
    // Github User 이름
    @Published var username: String? = UserInfo.gitLogin
    
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
        // 현재 달의 일자 수 만큼 0으로 초기화
        let totalDays = daysInMonth.count
        self.dayAllCommitCount = Array(repeating: 0, count: totalDays)
        self.dayBlogCommitCount = Array(repeating: 0, count: totalDays)
    }
    
    func fetchContributions(for username: String) {
        let calendar = Calendar.current
        var comps = DateComponents(year: currentYear, month: currentMonth, day: 1)
        guard let startDate = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: startDate) else { return }
        let totalDays = range.count
        comps.day = totalDays
        guard let rawEndDate = calendar.date(from: comps) else { return }
            // endDate를 23:59:59로 변경하여 해당 날짜의 마지막 순간까지 포함되도록 합니다.
            guard let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: rawEndDate) else { return }
        
        GithubCommitFetchManager.shared.fetchContributionCountsInPeriod(username: username,
                                                        from: startDate,
                                                        to: endDate) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countsByDate):
                    self?.updateCommitCounts(with: countsByDate)
                case .failure(let error):
                    print("Failed to fetch contributions: \(error)")
                }
            }
        }
    }
    
    func fetchBlogContributions(for username: String) {
        let calendar = Calendar.current
        var comps = DateComponents(year: currentYear, month: currentMonth, day: 1)
        guard let startDate = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: startDate) else { return }
        let totalDays = range.count
        comps.day = totalDays
        guard let rawEndDate = calendar.date(from: comps) else { return }
            // endDate를 23:59:59로 변경하여 해당 날짜의 마지막 순간까지 포함되도록 합니다.
            guard let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: rawEndDate) else { return }
        
        GithubCommitFetchManager.shared.fetchBlogContributionCountsInPeriod(username: username,
                                                                            from: startDate,
                                                                            to: endDate) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countsByDate):
                    // 여기서 countsByDate는 "yyyy-MM-dd" 형식의 키와 커밋 수를 담고 있음
                    print("디코딩된 Blog Contribution countsByDate: \(countsByDate)")
                    // 이를 바탕으로 dayBlogCommitCount 배열을 업데이트 합니다.
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    var newCounts: [Int] = []
                    var comps = DateComponents(year: self?.currentYear, month: self?.currentMonth, day: 1)
                    for day in 1...totalDays {
                        comps.day = day
                        if let date = calendar.date(from: comps) {
                            let key = dateFormatter.string(from: date)
                            let count = countsByDate[key] ?? 0
                            newCounts.append(count)
                        }
                    }
                    self?.dayBlogCommitCount = newCounts
                case .failure(let error):
                    print("Failed to fetch blog contributions: \(error)")
                }
            }
        }
    }

    private func updateCommitCounts(with countsByDate: [String: Int]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // (타임존이 문제가 될 경우 아래와 같이 설정할 수 있음)
        // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        var newCounts: [Int] = []
        let calendar = Calendar.current
        var comps = DateComponents(year: currentYear, month: currentMonth, day: 1)
        
        // 오늘 날짜 관련 계산
        let todayComps = calendar.dateComponents([.day, .month, .year], from: Date())
        let totalDays = daysInMonth.count
        let dayLimit: Int = (currentYear == todayComps.year && currentMonth == todayComps.month)
            ? (todayComps.day ?? totalDays)
            : totalDays
        
        for day in 1...totalDays {
            comps.day = day
            if let date = calendar.date(from: comps) {
                let key = dateFormatter.string(from: date)
                let count = (day <= dayLimit) ? (countsByDate[key] ?? 0) : 0
                newCounts.append(count)
            }
        }
        self.dayAllCommitCount = newCounts
        // dayBlogCommitCount도 동일한 길이로 초기화 (혹은 실제 데이터로 업데이트)
        self.dayBlogCommitCount = Array(repeating: 0, count: totalDays)
    }
}
