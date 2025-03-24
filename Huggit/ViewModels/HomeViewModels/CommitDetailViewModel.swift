//
//  CommitDetailViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI
import Combine

final class CommitDetailViewModel: ObservableObject {
    // Github User 이름
    @Published var username: String? = nil
    
    @Published var arrowPosition: CGFloat = 0.5
    @Published var selectedCellFrame: CGRect? = nil
    @Published var selectedYear: Int = 2025
    @Published var selectedMonth: Int = 3
    @Published var selectedDay: Int = 1
    
    // 각 날짜별 contribution 정보를 저장하는 딕셔너리
    @Published var contributionDetailsByDay: [Int: [ContributionDetail]] = [:]
    
    // 현재 선택된 날짜의 contribution 정보
    @Published var contributionDetails: [ContributionDetail] = [] // Repo 이름, 메시지들 Repo 이름, 커밋 메시지들
    
    // 잔디 타입을 저장 (홈에서 calendarViewModel의 currentGrass와 동기화)
    @Published var currentGrass: CurrentGrass = .allGrass
    
    private var cancellables = Set<AnyCancellable>()
    
    func updateSelection(cellFrame: CGRect, containerFrame: CGRect, day: Int, horizontalPadding: CGFloat) {
        let tooltipWidth = containerFrame.width - horizontalPadding * 2
        let computedArrowPosition = (cellFrame.midX - containerFrame.minX - horizontalPadding) / tooltipWidth
        arrowPosition = computedArrowPosition
        selectedCellFrame = cellFrame
        selectedDay = day
    }
    
    func clearSelection() {
        selectedCellFrame = nil
        contributionDetails = []
    }
    
    // 기존의 개별 날짜에 대해 contribution
    func fetchContributionDetails(for username: String, on date: Date, completion: @escaping ([ContributionDetail]) -> Void) {
        GithubCommitFetchManager.shared.fetchContributionDetails(for: username, on: date) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    completion(details)
                case .failure(let error):
                    print("fetchContributionDetails: 에러 발생 - \(error)")
                    completion([])
                }
            }
        }
    }
    
    // 이번 달의 모든 날짜에 대한 contribution
    func fetchAllContributionDetails(for username: String) {
        let calendar = Calendar.current
        // 현재 달의 1일 날짜 계산
        guard let startOfMonth = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return }
        let totalDays = range.count
        
        let dispatchGroup = DispatchGroup()
        
        // 각 날짜에 대해 API 호출
        for day in 1...totalDays {
            let comps = DateComponents(year: selectedYear, month: selectedMonth, day: day)
            guard let date = calendar.date(from: comps) else { continue }
            
            dispatchGroup.enter()
            fetchContributionDetails(for: username, on: date) { details in
                self.contributionDetailsByDay[day] = details
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // API 호출이 모두 완료되면, 선택된 날짜의 데이터를 contributionDetails에 반영
            if let selected = self.contributionDetailsByDay[self.selectedDay] {
                self.contributionDetails = selected
            }
        }
    }
    
    // 필터링 함수: currentGrass 값에 따라 ContributionDetail 배열을 필터링
    // TODO: 레포 이름 따로 저장해서 사용하는 것으로 수정
    func filterContributionDetails(_ details: [ContributionDetail]) -> [ContributionDetail] {
        switch currentGrass {
        case .allGrass:
            return details
        case .codeGrass:
            // NewRepo1 관련 내역은 제외 (대소문자 주의: "NewRepo1")
            return details.filter { $0.repositoryName != "NewRepo1" }
        case .blogGrass:
            // 오직 NewRepo1의 내역만 포함
            return details.filter { $0.repositoryName == "NewRepo1" }
        }
    }
    
    // 모든 contribution 메시지의 총 개수
    var totalContributionCount: Int {
        contributionDetails.reduce(0) { $0 + $1.messages.count }
    }
}
