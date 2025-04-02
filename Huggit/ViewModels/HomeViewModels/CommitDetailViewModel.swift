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
    @Published var username: String = UserInfo.gitLogin
    
    @Published var arrowPosition: CGFloat = 0.5
    @Published var selectedCellFrame: CGRect? = nil
    @Published var selectedYear: Int = 2025
    @Published var selectedMonth: Int = 3
    @Published var selectedDay: Int = 1 {
        didSet {
            contributionDetails = contributionDetailsByDay[selectedDay] ?? []
        }
    }
    
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
    
    // 필터링 함수: currentGrass 값에 따라 ContributionDetail 배열을 필터링
    func filterContributionDetails(_ details: [ContributionDetail]) -> [ContributionDetail] {
        switch currentGrass {
        case .allGrass:
            return details
        case .codeGrass:
            return details.filter { $0.repositoryName != UserInfo.repoName }
        case .blogGrass:
            return details.filter { $0.repositoryName == UserInfo.repoName }
        }
    }
    
    // 모든 contribution 메시지의 총 개수
    var totalContributionCount: Int {
        contributionDetails.reduce(0) { $0 + $1.messages.count }
    }
}
