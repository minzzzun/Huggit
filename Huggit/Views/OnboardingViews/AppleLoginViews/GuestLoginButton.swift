//
//  GuestLoginButton.swift
//  Huggit
//
//  Created by Minhyeok Kim on 6/3/25.
//

import SwiftUI

struct GuestLoginButton: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        
        Button(action: {
            print("Guest로 로그인")
            router.offAll("/")
        }) {
            HStack(alignment: .center, spacing: 6) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.primaryWhite)
                Text("Guest로 로그인")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundColor(.primaryWhite)
            }
            .frame(width: UIScreen.main.bounds.width - 40)
            .frame(height: 64)
            .background(Color.black)
            .cornerRadius(8)
        }
    }
}

