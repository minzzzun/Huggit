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
    let horizontalPadding = 21.0
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - (horizontalPadding * 2)
            let computedSpacing = (availableWidth - (cellWidth * Double(numberOfColumns))) / Double(numberOfColumns - 1)
            
            let columns: [GridItem] = Array(
                repeating: GridItem(.fixed(cellWidth), spacing: computedSpacing),
                count: numberOfColumns
            )
            ZStack {
                VStack {
                    CalendarHeaderView()
                        .padding(.bottom, 27)
                    // 요일 헤더
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
                    
                    Spacer()
                }
                .padding(.horizontal, 21)
                if calendarViewModel.selectMonth {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            calendarViewModel.selectMonth = false
                        }
                    
                    VStack(spacing: 0) {
                        Picker("년도", selection: $calendarViewModel.currentYear) {
                            ForEach(2000...2030, id: \.self) { year in
                                Text("\(year)년").tag(year)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 120)
                        
                        Picker("월", selection: $calendarViewModel.currentMonth) {
                            ForEach(1...12, id: \.self) { month in
                                Text("\(month)월").tag(month)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 120)
                        
                        Button("확인") {
                            calendarViewModel.selectMonth = false
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
            }
            .environmentObject(calendarViewModel)
        }
    }
}
