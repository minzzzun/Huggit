//
//  UserInfoView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/12/25.
//

import SwiftUI

struct UserInfoView: View {
    @EnvironmentObject var viewModel: MyPageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("오늘도 성실한 개발자로 한발짝 더 성장!")
                .font(.system(size: 13))
                .foregroundStyle(Color.semiBlue)
            
            // TODO: 실제 UserName으로 바꾸기
            Text("\(viewModel.githubName)님")
                .font(.system(size: 23))
                .foregroundStyle(Color.primaryWhite)
                .padding(.top, 8)
                .padding(.bottom, 32)
            
            HStack {
                // TODO: 실제 월, 잔디수로 바꾸기
                Text("\(viewModel.currentMonth)월의 잔디 수")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray100)
                Spacer()
                Text("\(viewModel.totalCommitsThisMonth)개")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.primaryBlue)
            }
            .padding(17)
            .background(Color.gray500)
            .cornerRadius(14)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.gray600)
        )
    }
}
