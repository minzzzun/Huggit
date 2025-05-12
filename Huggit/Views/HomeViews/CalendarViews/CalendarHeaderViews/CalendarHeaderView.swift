//
//  CalendarHeaderView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI

struct CalendarHeaderView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var calendarViewModel: CalendarViewModel {
        homeViewModel.calendarViewModel
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 19) {
            CalendarHeaderButtonView(title: "전체 잔디", grassType: .allGrass, startColor: .codeGreen300, endColor: .codeBlue300)
            CalendarHeaderButtonView(title: "코드 잔디", grassType: .codeGrass, startColor: .codeGreen300, endColor: .codeGreen300)
            CalendarHeaderButtonView(title: "공부 잔디", grassType: .blogGrass, startColor: .codeBlue300, endColor: .codeBlue300)
            
            Spacer()
            
            Button(action: {
                calendarViewModel.selectMonth.toggle()
            }) {
                HStack {
                    Text("\(String(calendarViewModel.currentYear))년 \(calendarViewModel.currentMonth)월")
                        .font(.system(size: 12))
                        .foregroundColor(.primaryWhite)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
