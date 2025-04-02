//
//  HomeViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    // 하위 ViewModels
    @Published var calendarViewModel: CalendarViewModel
    @Published var commitDetailViewModel: CommitDetailViewModel
    @Published var homeHeaderViewModel: HomeHeaderViewModel
    @Published var commitListViewModel: CommitListViewModel
    @Published var commitCreateViewModel: CommitCreateViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    // 하위 ViewModels 관리
    init() {
        let calendarVM = CalendarViewModel()
        let commitDetailVM = CommitDetailViewModel()
        let homeHeaderVM = HomeHeaderViewModel(dayAllCommitCount: calendarVM.dayAllCommitCount)
        let commitListVM = CommitListViewModel()
        let commitCreateVM = CommitCreateViewModel()
        
        self.calendarViewModel = calendarVM
        self.commitDetailViewModel = commitDetailVM
        self.homeHeaderViewModel = homeHeaderVM
        self.commitListViewModel = commitListVM
        self.commitCreateViewModel = commitCreateVM
        
        // calendarViewModel 변경 감지
        calendarViewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        calendarViewModel.$currentYear
            .sink { [weak self] newYear in
                self?.commitDetailViewModel.selectedYear = newYear
            }
            .store(in: &cancellables)
        
        calendarViewModel.$currentMonth
            .sink { [weak self] newMonth in
                self?.homeHeaderViewModel.selectedMonth = newMonth
                self?.commitDetailViewModel.selectedMonth = newMonth
            }
            .store(in: &cancellables)
        
        calendarViewModel.$dayAllCommitCount
            .sink { [weak self] newCounts in
                guard let self = self else { return }
                // 최신 전체 데이터를 업데이트
                self.homeHeaderViewModel.dayAllCommitCount = newCounts
                
                // snapshot이 아직 비어있으면 한 번만 업데이트
                self.homeHeaderViewModel.updateCommitsInThisMonth(with: newCounts)
            }
            .store(in: &cancellables)
        
        calendarViewModel.$currentGrass
            .sink { newGrass in
                self.commitDetailViewModel.currentGrass = newGrass
            }
            .store(in: &cancellables)
        
        // commitDetailViewModel 변경 감지
        commitDetailViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        commitListViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        // commitCreateViewModel 변경 감지
        commitCreateViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        loadAllData()
    }
    
    // 전체 데이터 로드
    func loadAllData() {
        self.loadContributionDataInCurrentMonth()
    }
    
    // 이번 달의 커밋 데이터 불러오기
    func loadContributionDataInCurrentMonth() {
        guard !UserInfo.gitLogin.isEmpty else {
            print("GitHub 사용자 정보가 아직 로드되지 않음")
            return
        }
        let username = UserInfo.gitLogin
        
        calendarViewModel.fetchContributions(for: username)
        calendarViewModel.fetchBlogContributions(for: username)
        commitDetailViewModel.fetchAllContributionDetails(for: username)
    }
}
