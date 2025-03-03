//
//  CalendarView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var calendarViewModel = CalendarViewModel()
    
    let cellWidth = 29.0
    let numberOfColumns = 7
    let rowsPadding = 12.0
    
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
                                    CalendarCellView(
                                        day: day,
                                        size: cellWidth,
                                        // 코드 커밋 수는 전체 커밋에서 블로그 커밋 수를 뺀 값
                                        codeCommitCount: calendarViewModel.dayAllCommitCount[commitIndex] - calendarViewModel.dayBlogCommitCount[commitIndex],
                                        blogCommitCount: calendarViewModel.dayBlogCommitCount[commitIndex]
                                    )
                                    .environmentObject(calendarViewModel)
                                } else {
                                    CalendarCellView(
                                        day: nil,
                                        size: cellWidth,
                                        codeCommitCount: nil,
                                        blogCommitCount: nil
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
                            .environmentObject(calendarViewModel)
                            .frame(width: 150, height: 4 * 44)
                            .padding(.top, 1)
                    }
                }
                Spacer()
            }
            .environmentObject(calendarViewModel)
        }
    }
}
