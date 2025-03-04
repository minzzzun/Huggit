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
    @Published var selectedCommitCount: Int = 0
    @Published var selectedYear: Int = 2025
    @Published var selectedMonth: Int = 3
    @Published var selectedDay: Int = 1
    
    @Published var commitDetails: [CommitDetail] = [] // Repo 이름, 커밋 메시지들
    
    private var cancellables = Set<AnyCancellable>()
    
    func updateSelection(cellFrame: CGRect, containerFrame: CGRect, commitCount: Int, day: Int, horizontalPadding: CGFloat) {
        let tooltipWidth = containerFrame.width - horizontalPadding * 2
        let computedArrowPosition = (cellFrame.midX - containerFrame.minX - horizontalPadding) / tooltipWidth
        arrowPosition = computedArrowPosition
        selectedCellFrame = cellFrame
        selectedCommitCount = commitCount
        selectedDay = day
    }
    
    func clearSelection() {
        selectedCellFrame = nil
    }
    
    // 커밋 내역 가져오는 함수
    func fetchCommitDetails(for username: String, on date: Date) {
        print("fetchCommitDetails: 시작 - \(username), 날짜: \(date)")
        GithubCommitFetchManager.shared.fetchCommitHistory(for: username, on: date) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.commitDetails = details
                    print("fetchCommitDetails: 성공 - 커밋 섹션 수: \(self.commitDetails.count)")
                case .failure(let error):
                    print("fetchCommitDetails: 에러 발생 - \(error)")
                    self.commitDetails = []
                }
            }
        }
    }
}
