//
//  MonthSelectionModalView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct MonthSelectionModalView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    // 현재 선택된 (연, 월)부터 30개월 분 데이터를 생성합니다.
    var months: [(year: Int, month: Int, date: Date)] {
        let calendar = Calendar.current
        let currentComponents = DateComponents(year: calendarViewModel.currentYear, month: calendarViewModel.currentMonth)
        guard let currentDate = calendar.date(from: currentComponents) else { return [] }
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
                    }) {
                        Text("\(item.year)년 \(item.month)월")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .foregroundColor(.black)
                    }
                    if item.date != months.last?.date {
                        Divider()
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}
