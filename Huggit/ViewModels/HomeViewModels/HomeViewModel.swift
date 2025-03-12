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
        let homeHeaderVM = HomeHeaderViewModel(dayAllCommitCount: calendarVM.dayAllCommitCount)
        let commitListVM = CommitListViewModel()
        let commitCreateVM = CommitCreateViewModel()
        
        self.calendarViewModel = calendarVM
        self.commitDetailViewModel = commitDetailVM
        self.homeHeaderViewModel = homeHeaderVM
        self.commitListViewModel = commitListVM
        self.commitCreateViewModel = commitCreateVM
        
        
        calendarViewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                 self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        // `calendarViewModel.dayAllCommitCount` 변경 감지 → `homeHeaderViewModel` 자동 업데이트
        calendarViewModel.$dayAllCommitCount
            .sink { [weak self] newCommitCounts in
                self?.homeHeaderViewModel.dayAllCommitCount = newCommitCounts
            }
            .store(in: &cancellables)

        // `commitDetailViewModel` 변경 감지
        commitDetailViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        // `commitCreateViewModel` 변경 감지
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
                    self?.loadAllData()
                case .failure(let error):
                    print("Error fetching GitHub user: \(error)")
                }
            }
        }
    }
    
    // 전체 데이터 로드
    func loadAllData() {
        self.loadContributionDataInCurrentMonth()
    }
    
    // 이번 달의 커밋 데이터 불러오기
    func loadContributionDataInCurrentMonth() {
        guard let username = githubUser?.login else {
            print("GitHub 사용자 정보가 아직 로드되지 않음")
            return
        }
        
        calendarViewModel.fetchContributions(for: username)
        commitDetailViewModel.fetchAllContributionDetails(for: username)
    }
}
