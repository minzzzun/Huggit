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
            viewModel.checkAppleLogin()
            if viewModel.isAppleLogined {
//                router.toNamed("/") // 테스트 끝나면 원상복구
                router.toNamed("/appleLogin")
            } else {
                router.toNamed("/appleLogin")
            }
        }
    }
}
