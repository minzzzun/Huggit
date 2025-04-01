//
//  UseInfoView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/12/25.
//

import SwiftUI

struct UseInfo {
    let name: String
    let action: () -> Void
}

struct UseInfoView: View {
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @EnvironmentObject var router: NavigationRouter
    
    var useInfos: [UseInfo] {
        [
            UseInfo(name: "개인정보 처리방침", action: {
                // 개인정보 처리방침 액션 처리
            }),
            UseInfo(name: "서비스 이용 약관", action: {
                // 서비스 이용 약관 액션 처리
            }),
            UseInfo(name: "로그아웃", action: {
                myPageViewModel.logout {
                    router.offAll("/appleLogin")
                }
            }),
            UseInfo(name: "탈퇴하기", action: {
                // 탈퇴하기 액션 처리
            })
        ]
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("이용 안내")
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .padding(.bottom, 20)
            VStack (spacing: 28) {
                ForEach(useInfos.indices, id: \.self) { index in
                    let useInfo = useInfos[index]
                    
                    HStack {
                        Text(useInfo.name)
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                        Spacer()
                        Button(action: useInfo.action) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white)
                                .scaledToFit()
                                .frame(height: 8)
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 11)
                    .fill(Color.gray)
            )
        }
    }
}
