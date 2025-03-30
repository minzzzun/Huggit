//
//  ContentView.swift
//  Huggit
//
//  Created by 김민준 on 2/19/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Color.clear
                .navigationDestination(for: Route.self) { route in
                    switch route.name {
                    case "/":
                        HomeView()
                    case "/appleLogin":
                        AppleLoginView()
                    case "/githubLogin":
                        GithubLoginView()
                    case "/tistoryView":
                        TistoryView()
                    case "/velogView":
                        VelogView()
                    case "/mypageView":
                        MyPageView()
                        
                        
                    default:
                        Text("알 수 없는 경로 : \(route.name) ")
                    }
                    
                }
        }
        .environmentObject(router)
        // 애플 로그인 한적 있는지 확인
        .onAppear {
            // 유효성 검사(애플, 깃허브, Velog, Tistory)
            router.updateLoginStatus {
                if router.loginRouteStack.isEmpty {
                    router.offAll("/")
                } else {
                    router.offAll(router.popNextLoginRoute())
                }
            }
        }
        
        // 알림 권한이 거부되었을 때 설정으로 이동할 수 있는 alert 표시
        .alert("알림 권한 필요", isPresented: $viewModel.showNotificationSettingsAlert) {
            Button("설정으로 이동") {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("앱의 알림을 받으려면 설정에서 권한을 활성화해주세요.")
        }
    }
}
