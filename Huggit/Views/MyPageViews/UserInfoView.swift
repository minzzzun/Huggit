//
//  UserInfoView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/12/25.
//

import SwiftUI

struct UserInfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("오늘도 성실한 개발자로 한발짝 더 성장!")
                .font(.system(size: 13))
                .foregroundStyle(.blue)
            
            // TODO: 실제 UserName으로 바꾸기
            Text("김민준님")
                .font(.system(size: 23))
                .foregroundStyle(.white)
                .padding(.top, 8)
                .padding(.bottom, 32)
            
            HStack {
                // TODO: 실제 월, 잔디수로 바꾸기
                Text("2월의 잔디 수")
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                Spacer()
                Text("20개")
                    .font(.system(size: 13))
                    .foregroundStyle(.blue)
            }
            .padding(17)
            .background(.orange)
            .cornerRadius(14)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.gray)
        )
    }
}
