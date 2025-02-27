//
//  HuggitApp.swift
//  Huggit
//
//  Created by 김민준 on 2/19/25.
//

import SwiftUI

@main
struct HuggitApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            
            AppleLoginView()
                .preferredColorScheme(.light)
        }
    }
}
