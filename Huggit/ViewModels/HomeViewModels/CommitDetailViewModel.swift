//
//  CommitDetailViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI
import Combine

final class CommitDetailViewModel: ObservableObject {
    @Published var arrowPosition: CGFloat = 0.5
    @Published var selectedCellFrame: CGRect? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func updateSelection(cellFrame: CGRect, containerFrame: CGRect, horizontalPadding: CGFloat) {
        let tooltipWidth = containerFrame.width - horizontalPadding * 2
        let computedArrowPosition = (cellFrame.midX - containerFrame.minX - horizontalPadding) / tooltipWidth
        arrowPosition = computedArrowPosition
        selectedCellFrame = cellFrame
    }
    
    func clearSelection() {
        selectedCellFrame = nil
    }
    
    /// 특정 날짜에 대한 Commit 이력을 불러오는 함수 
        func fetchCommitHistory(for username: String, on date: Date, completion: @escaping (Result<DayCommitHistory, GithubAPIError>) -> Void) {
            GithubCommitManager.shared.fetchCommitHistory(for: username, on: date, completion: completion)
        }
}
