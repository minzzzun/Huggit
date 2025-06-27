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
    
    @State private var showLogoutModal = false
    @State private var showDeleteAccountModal = false

    var body: some View {
        ZStack {
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
                    
                    // 피드백 설문 폼
                    FeedbackView()
                        .padding(.top, 20)
                    
                    // 계정 정보
                    AccountInfoView()
                        .padding(.top, 40)
                    
                    // 이용 안내
                    UseInfoView(showLogoutModal: $showLogoutModal, showDeleteAccountModal: $showDeleteAccountModal)
                                            .padding(.top, 40)
                    
                }
                .padding(.horizontal, 20)
            }
            .background(Color.primaryDarkBlue)
            .environmentObject(myPageViewModel)
            .navigationBarHidden(true)
            
            // 로그아웃 모달
            if showLogoutModal {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showLogoutModal = false
                    }
                LogoutModalView(isPresented: $showLogoutModal) {
                    myPageViewModel.logout {
                        router.offAll("/appleLogin")
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // 회원탈퇴 모달
            if showDeleteAccountModal {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showDeleteAccountModal = false
                    }
                DeleteAccountModalView(isPresented: $showDeleteAccountModal) {
                    myPageViewModel.logout { // 회원탈퇴로 변경
                        router.offAll("/appleLogin")
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}
