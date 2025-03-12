//
//  CalendarView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI

struct CellInfo {
    let frame: CGRect
    let day: Int?
}

struct CalendarView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var calendarViewModel: CalendarViewModel {
        homeViewModel.calendarViewModel
    }
    
    let cellWidth = 29.0
    let numberOfColumns = 7
    let rowsPadding = 12.0
    
    let onCellSelect: (CellInfo) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let computedSpacing = (availableWidth - (cellWidth * Double(numberOfColumns))) / Double(numberOfColumns - 1)
            
            let columns: [GridItem] = Array(
                repeating: GridItem(.fixed(cellWidth), spacing: computedSpacing),
                count: numberOfColumns
            )
            VStack {
                CalendarHeaderView()
                ZStack (alignment: .topTrailing){
                    // 요일 헤더
                    VStack {
                        LazyVGrid(columns: columns, spacing: rowsPadding) {
                            ForEach(calendarViewModel.daysOfTheWeek, id: \.self) { day in
                                Text(day)
                                    .font(.system(size: 9))
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 15)
                        
                        // 날짜 셀
                        LazyVGrid(columns: columns, spacing: rowsPadding) {
                            ForEach(0..<calendarViewModel.daysInMonthWithPadding.count, id: \.self) { index in
                                if let day = calendarViewModel.daysInMonthWithPadding[index] {
                                    let offset = calendarViewModel.firstWeekday - 1
                                    let commitIndex = index - offset
                                    if commitIndex >= 0 &&
                                        commitIndex < calendarViewModel.dayAllCommitCount.count &&
                                        commitIndex < calendarViewModel.dayBlogCommitCount.count {
                                        let allCommitCount = calendarViewModel.dayAllCommitCount[commitIndex]
                                        let blogCommitCount = calendarViewModel.dayBlogCommitCount[commitIndex]
                                        CalendarCellView(
                                            day: day,
                                            size: cellWidth,
                                            codeCommitCount: allCommitCount - blogCommitCount,
                                            blogCommitCount: blogCommitCount,
                                            onSelect: { cellFrame in
                                                let cellInfo = CellInfo(frame: cellFrame, day: day)
                                                onCellSelect(cellInfo)
                                            }
                                        )
                                    } else {
                                        CalendarCellView(
                                            day: day,
                                            size: cellWidth,
                                            codeCommitCount: 0,
                                            blogCommitCount: 0,
                                            onSelect: { cellFrame in
                                                let cellInfo = CellInfo(frame: cellFrame, day: day)
                                                onCellSelect(cellInfo)
                                            }
                                        )
                                    }
                                } else {
                                    CalendarCellView(
                                        day: nil,
                                        size: cellWidth,
                                        codeCommitCount: nil,
                                        blogCommitCount: nil,
                                        onSelect: { _ in }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.top, 27)
                    if calendarViewModel.selectMonth {
                        // 배경 터치시 모달 닫힘
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                calendarViewModel.selectMonth = false
                            }
                        
                        // 월 선택 모달 (기본 4개 항목 보임, 총 30개 항목 스크롤 가능)
                        MonthSelectionModalView()
                            .frame(width: 94, height: 109)
                            .padding(.top, 1)
                    }
                }
            }
        }
    }
}
