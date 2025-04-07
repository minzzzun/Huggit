//
//  HomeViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    // MARK: 하위 ViewModel
    @Published var calendarViewModel: CalendarViewModel
    @Published var commitDetailViewModel: CommitDetailViewModel
    @Published var homeHeaderViewModel: HomeHeaderViewModel
    @Published var commitListViewModel: CommitListViewModel
    @Published var commitCreateViewModel: CommitCreateViewModel

    // MARK: HomeViewModel -> 하위 ViewModel 데이터
    @Published var currentYear: Int = Calendar.current.component(.year, from: Date())
    @Published var currentMonth: Int = Calendar.current.component(.month, from: Date())
    @Published var contributionDetailsByDay: [Int: [ContributionDetail]] = [:]
    
    // 커밋 푸시 됐을 때 토스트
    @Published var showCommitPushToast: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let calendarVM = CalendarViewModel()
        let commitDetailVM = CommitDetailViewModel()
        let homeHeaderVM = HomeHeaderViewModel()
        let commitListVM = CommitListViewModel()
        let commitCreateVM = CommitCreateViewModel()
        
        self.calendarViewModel = calendarVM
        self.commitDetailViewModel = commitDetailVM
        self.homeHeaderViewModel = homeHeaderVM
        self.commitListViewModel = commitListVM
        self.commitCreateViewModel = commitCreateVM
        
        // MARK: 하위 ViewModel 변경 감지 (이거 안하면, UI 업데이트 안됨)
        calendarViewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        commitDetailViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        homeHeaderViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        commitListViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        commitCreateViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        // MARK: HomeViewModel -> 하위 ViewModel 데이터
        $currentYear
            .removeDuplicates()
            .sink { [weak self] newYear in
                self?.calendarViewModel.currentYear = newYear
                self?.commitDetailViewModel.selectedYear = newYear
                self?.fetchAllContributionDetails(for: UserInfo.gitLogin)
            }
            .store(in: &cancellables)
        
        $currentMonth
            .removeDuplicates()
            .sink { [weak self] newMonth in
                self?.homeHeaderViewModel.selectedMonth = newMonth
                self?.calendarViewModel.currentMonth = newMonth
                self?.commitDetailViewModel.selectedMonth = newMonth
                self?.fetchAllContributionDetails(for: UserInfo.gitLogin)
            }
            .store(in: &cancellables)
        
        $contributionDetailsByDay
            .sink { [weak self] newDetails in
                self?.homeHeaderViewModel.contributionDetailsByDay = newDetails
                self?.calendarViewModel.contributionDetailsByDay = newDetails
                self?.commitDetailViewModel.contributionDetailsByDay = newDetails
            }
            .store(in: &cancellables)
        
        // MARK: 하위 ViewModel -> 하위 ViewModel 데이터
        calendarViewModel.$currentYear
            .sink { [weak self] newYear in
                self?.currentYear = newYear
            }
            .store(in: &cancellables)
        
        calendarViewModel.$currentMonth
            .sink { [weak self] newMonth in
                self?.currentMonth = newMonth
            }
            .store(in: &cancellables)
        
        calendarViewModel.$currentGrass
            .sink { newGrass in
                self.commitDetailViewModel.currentGrass = newGrass
            }
            .store(in: &cancellables)
        
        commitListViewModel.$selectedCommit
            .sink { newCommit in
                self.commitCreateViewModel.selectedCommit = newCommit
            }
            .store(in: &cancellables)
        
        // MARK: CommitCreateView 커밋 성공 클로저
        commitCreateViewModel.onCommitPushSuccess = { [weak self] pushedCommit in
            guard let self = self else { return }
            
            // loadAllData를 하지 않는 이유: Post를 새로 가지고 와서 다시 넣어주면, 애니메이션 적용 안됨
            self.self.fetchAllContributionDetails(for: UserInfo.gitLogin)
            withAnimation(.easeInOut(duration: 1.0)) {
                self.commitListViewModel.commitList.removeAll { $0.id == pushedCommit.id }
            }
            self.commitListViewModel.selectedCommit = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showToastMessage()
            }
        }
        
        loadAllData()
    }
    
    // 전체 데이터 로드
    func loadAllData() {
        self.fetchAllContributionDetails(for: UserInfo.gitLogin)
        commitListViewModel.fetchPosts()
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
        self.contributionDetailsByDay = [:]
        let calendar = Calendar.current
        // 현재 달의 1일 날짜 계산
        guard let startOfMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return }
        let totalDays = range.count
        
        // 각 날짜에 대해 API 호출
        for day in 1...totalDays {
            let comps = DateComponents(year: currentYear, month: currentMonth, day: day)
            guard let date = calendar.date(from: comps) else { continue }
            
            fetchContributionDetails(for: username, on: date) { details in
                self.contributionDetailsByDay[day] = details
            }
        }
    }
    
    // 커밋 푸시 토스트
    func showToastMessage() {
        withAnimation(.easeInOut(duration: 1.0)) {
            showCommitPushToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 1.0)) {
                self.showCommitPushToast = false
            }
        }
    }
}
