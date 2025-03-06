//
//  HuggitApp.swift
//  Huggit
//
//  Created by 김민준 on 2/19/25.
//

import SwiftUI

@main
struct HuggitApp: App {
    
    @StateObject private var viewModel = GithubLoginViewModel()
    var body: some Scene {
        WindowGroup {
            VelogView()
//            ContentView()
                .preferredColorScheme(.light)
                                .environmentObject(viewModel)
            
                
        }
    }
}
