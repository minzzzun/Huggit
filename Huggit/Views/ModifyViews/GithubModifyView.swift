//
//  GithubModifyView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/9/25.
//

import SwiftUI

struct GithubModifyView: View {
    @StateObject private var viewModel = GithubModifyViewModel()
    @EnvironmentObject var router : NavigationRouter
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.primaryDarkBlue)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // HeaderView
                OnboardingHeaderView(loginStep: 1)
                Spacer()
                    .frame(height: 50)
                
                // BodyView
                HStack {
                    // GitHub 로고와 텍스트
                    VStack(alignment: .leading ,spacing: 15) {
                        Image("githubLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .padding(.bottom, 15)
                        
                        VStack(alignment: .leading,spacing: 8) {
                            Text("새로운 깃허브 연동이")
                                .font(.system(size: 24, weight: .bold))
                            Text("필요해요!")
                                .font(.system(size: 24, weight: .bold))
                        }
                        
                        Text("교체할 깃허브 계정으로 로그인 해주세요!")
                            .font(.system(size: 14))
                            .foregroundColor(.blueButton)
                    }// v
                    Spacer()
                }
                
                Spacer()
                
                // 깃허브 로그인 버튼
                Button(action: {
                    viewModel.requestCode()
                }) {
                    Text("깃허브 로그인")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color.blueButton)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoggingIn)
                .padding(.bottom, 58)
            }
            .padding(.horizontal, 20)
            
        }
        .foregroundColor(.white)
        .navigationBarHidden(true)
        .onOpenURL { url in
            print("🔗 URL received: \(url)")
            
            guard url.scheme == "githubprviewer", url.host == "login" else {
                print("❌ Invalid URL Scheme or Host: \(url)")
                return
            }
            
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let queryItems = components.queryItems,
               let code = queryItems.first(where: { $0.name == "code" })?.value {
                print("✅ GitHub Authorization Code: \(code)")
                viewModel.requestAccessToken(code: code)
            } else {
                print("❌ Failed to extract code from URL")
            }
        }
        .onAppear() {
            viewModel.isAuthenticated = false
        }
        // 로그인 완료 상태 감지 후 화면 전환
        .onChange(of: viewModel.isAuthenticated) { newValue in
            if newValue {
                viewModel.isLoggingIn = false
                router.back()
            }
        }
    }
}

