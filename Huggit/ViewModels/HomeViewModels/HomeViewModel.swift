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
    
    // HomeView Publishers
    @Published var githubUser: GithubUser?
    
    private var cancellables = Set<AnyCancellable>()
    
    // 하위 ViewModels 관리
    init() {
        let calendarVM = CalendarViewModel()
        let commitDetailVM = CommitDetailViewModel()
        let homeHeaderVM = HomeHeaderViewModel(dayAllCommitCount: calendarVM.dayAllCommitCount,
                                               historicalDayAllCommitCounts: calendarVM.historicalDayAllCommitCounts ?? [])
        let commitListVM = CommitListViewModel()
        let commitCreateVM = CommitCreateViewModel()
        
        self.calendarViewModel = calendarVM
        self.commitDetailViewModel = commitDetailVM
        self.homeHeaderViewModel = homeHeaderVM
        self.commitListViewModel = commitListVM
        self.commitCreateViewModel = commitCreateVM
        
        
        calendarViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
            self?.homeHeaderViewModel.dayAllCommitCount = self?.calendarViewModel.dayAllCommitCount ?? []
            self?.homeHeaderViewModel.historicalDayAllCommitCounts = self?.calendarViewModel.historicalDayAllCommitCounts ?? []
            
            self?.commitDetailViewModel.selectedYear = self?.calendarViewModel.currentYear ?? 2025
            self?.commitDetailViewModel.selectedMonth = self?.calendarViewModel.currentMonth ?? 3
        }.store(in: &cancellables)
        
        commitDetailViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        commitCreateViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        fetchGithubUser()
    }
    
    // Github 유저 정보 불러오기
    func fetchGithubUser() {
        GithubUserManager.shared.fetchUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.githubUser = user
                    self?.calendarViewModel.username = user.login
                    self?.commitDetailViewModel.username = user.login
                    // 사용자 정보가 로드되면 HomeViewModel에서 모든 데이터를 한 번에 불러옵니다.
                    self?.loadAllData()
                case .failure(let error):
                    print("Error fetching GitHub user: \(error)")
                }
            }
        }
    }
    
    func loadAllData() {
        self.loadContributionDataInCurrentMonth()
    }
    
    func loadContributionDataInCurrentMonth() {
        guard let username = githubUser?.login else {
            print("GitHub 사용자 정보가 아직 로드되지 않음")
            return
        }
        
        // 현재 달의 contributions
        calendarViewModel.fetchContributions(for: username)
        
        homeHeaderViewModel.dayAllCommitCount = calendarViewModel.dayAllCommitCount
        homeHeaderViewModel.historicalDayAllCommitCounts = calendarViewModel.historicalDayAllCommitCounts ?? []
        homeHeaderViewModel.calculateCommitStreak()
        
        commitDetailViewModel.fetchAllContributionDetails(for: username)
        
        // TODO: CommitListViewModel을 통해 Tistory, Velog 정보 불러오기
    }
}
