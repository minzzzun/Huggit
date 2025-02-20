//
//  ContentView.swift
//  Huggit
//
//  Created by 김민준 on 2/19/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()

    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
            .navigationDestination(for: Route.self) { route in
                switch route.name {
                case "/":
                    HomeView()
                default:
                    Text("알 수 없는 경로 : \(route.name) ")
                }
                
            }
        }.environmentObject(router)
    }
}

#Preview {
    ContentView()
}
