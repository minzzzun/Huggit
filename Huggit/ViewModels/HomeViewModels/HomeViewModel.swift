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
    
    // HomeView Publishers
    @Published var githubUser: GithubUser?
    
    private var cancellables = Set<AnyCancellable>()
    
    // 하위 ViewModels 관리
    init() {
        let calendarVM = CalendarViewModel()
        let commitDetailVM = CommitDetailViewModel()
        let homeHeaderVM = HomeHeaderViewModel(dayAllCommitCount: calendarVM.dayAllCommitCount,
                                               historicalDayAllCommitCounts: calendarVM.historicalDayAllCommitCounts ?? [])
        self.calendarViewModel = calendarVM
        self.commitDetailViewModel = commitDetailVM
        self.homeHeaderViewModel = homeHeaderVM
        
        calendarViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
            self?.homeHeaderViewModel.dayAllCommitCount = self?.calendarViewModel.dayAllCommitCount ?? []
            self?.homeHeaderViewModel.historicalDayAllCommitCounts = self?.calendarViewModel.historicalDayAllCommitCounts ?? []
        }.store(in: &cancellables)
        
        commitDetailViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
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
                case .failure(let error):
                    print("Error fetching GitHub user: \(error)")
                }
            }
        }
    }
}
