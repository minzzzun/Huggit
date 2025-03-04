//
//  HomeViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var calendarViewModel: CalendarViewModel
    @Published var commitDetailViewModel: CommitDetailViewModel
    @Published var homeHeaderViewModel: HomeHeaderViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let calendarVM = CalendarViewModel()
        let commitDetailVM = CommitDetailViewModel()
        
        self.calendarViewModel = calendarVM
        self.commitDetailViewModel = commitDetailVM
        self.homeHeaderViewModel = HomeHeaderViewModel(
            dayAllCommitCount: calendarVM.dayAllCommitCount,
            historicalDayAllCommitCounts: calendarVM.historicalDayAllCommitCounts ?? []
        )
        
        calendarViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
            self?.homeHeaderViewModel.dayAllCommitCount = self?.calendarViewModel.dayAllCommitCount ?? []
            self?.homeHeaderViewModel.historicalDayAllCommitCounts = self?.calendarViewModel.historicalDayAllCommitCounts ?? []
        }.store(in: &cancellables)
        
        commitDetailViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
}
