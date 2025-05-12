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
                    .textStyle(.s213M)
                    .padding(.top, 18)
                    .foregroundStyle(Color.semiBlue)
                (
                    Text("\(homeHeaderViewModel.selectedMonth)월에는 ")
                        .foregroundStyle(Color.gray000)
                    + Text("\(homeHeaderViewModel.commitsInMonth)개")
                        .foregroundStyle(Color.primaryBlue)
                    + Text("의\n잔디를 심었어요!")
                        .foregroundStyle(Color.gray000)
                )
                .textStyle(.h421M)
                .padding(.top, 5)
            }
            Spacer()
            StampView()
        }
    }
}
