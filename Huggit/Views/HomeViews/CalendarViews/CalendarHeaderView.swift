//
//  CalendarHeaderView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI

struct CalendarHeaderView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        HStack(spacing: 19) {
            CalendarHeaderButtonView(title: "전체 잔디", grassType: .allGrass, startColor: .greenMore, endColor: .blueMore)
            CalendarHeaderButtonView(title: "코드 잔디", grassType: .codeGrass, startColor: .greenMore, endColor: .greenMore)
            CalendarHeaderButtonView(title: "공부 잔디", grassType: .blogGrass, startColor: .blueMore, endColor: .blueMore)
            
            Spacer()
            
            Button(action: {
                calendarViewModel.selectMonth.toggle()
            }) {
                HStack {
                    Text("\(String(calendarViewModel.currentYear))년 \(calendarViewModel.currentMonth)월")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
