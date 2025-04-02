//
//  MonthSelectionModalView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct MonthSelectionModalView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var calendarViewModel: CalendarViewModel {
        homeViewModel.calendarViewModel
    }
    
    // 현재 선택된 (연, 월)부터 30개월 분 데이터를 생성합니다.
    var months: [(year: Int, month: Int, date: Date)] {
        let calendar = Calendar.current
        let currentDate = Date()  // 오늘 날짜
        return (0..<30).compactMap { offset in
            if let date = calendar.date(byAdding: .month, value: -offset, to: currentDate) {
                let comps = calendar.dateComponents([.year, .month], from: date)
                if let year = comps.year, let month = comps.month {
                    return (year, month, date)
                }
            }
            return nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(months, id: \.date) { item in
                    Button(action: {
                        calendarViewModel.currentYear = item.year
                        calendarViewModel.currentMonth = item.month
                        calendarViewModel.selectMonth = false
                        homeViewModel.fetchAllContributionDetails(for: UserInfo.gitLogin)
                    }) {
                        Text("\(String(item.year))년 \(item.month)월")
                            .foregroundColor(.white)
                            .font(.system(size: 11))
                    }
                    .frame(height: (109 - 1.5) / 4)
                    if item.date != months.last?.date {
                        Divider()
                            .frame(height: 0.5)
                    }
                }
            }
        }
        .background(.gray)
        .cornerRadius(5)
        .shadow(radius: 30)
    }
}
