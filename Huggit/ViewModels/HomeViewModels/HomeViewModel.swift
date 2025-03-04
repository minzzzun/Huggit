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
    
    init() {
        self.calendarViewModel = CalendarViewModel()
        self.commitDetailViewModel = CommitDetailViewModel()
        
        // 각 ViewModel의 변경사항을 감지하여 HomeViewModel을 업데이트
        calendarViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        commitDetailViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
}
