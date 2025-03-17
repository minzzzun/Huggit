//
//  HomeHeaderView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct HomeHeaderView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var homeHeaderViewModel: HomeHeaderViewModel {
        homeViewModel.homeHeaderViewModel
    }
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("오늘도 1일 1커밋을 향해!")
                    .foregroundStyle(.blue)
                    .font(.system(size: 12))
                    .padding(.top, 18)
                (
                    Text("\(homeHeaderViewModel.selectedMonth)월에는 ")
                        .foregroundStyle(.white)
                    + Text("\(homeHeaderViewModel.commitsInMonth)개")
                        .foregroundStyle(.blue)
                    + Text("의\n잔디를 심었어요!")
                        .foregroundStyle(.white)
                )
                .font(.system(size: 21))
                .padding(.top, 5)
            }
            Spacer()
            StampView()
        }
    }
}
