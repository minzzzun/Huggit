//
//  MyPageView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/11/25.
//

import SwiftUI

struct MyPageView: View {
    @StateObject var myPageViewModel = MyPageViewModel()
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                // 앱바
                AppBarView(
                    isHomeView: false,
                    title: "마이페이지",
                    buttonImage: "house",
                    action: {
                        router.offAll("/")
                    }
                )
                
                // 마이페이지_유저 이름 & 커밋 수
                UserInfoView()
                    .padding(.top, 15)
                    .environmentObject(myPageViewModel)
                
                // 피드백 설문 폼
                FeedbackView()
                    .padding(.top, 20)
                
                // 계정 정보
                AccountInfoView()
                    .padding(.top, 40)
                    .environmentObject(myPageViewModel)
                
                // 이용 안내
                UseInfoView()
                    .padding(.top, 40)
                
            }
            .padding(.horizontal, 20)
        }
        .background(.black)
        .navigationBarHidden(true)
    }
}
