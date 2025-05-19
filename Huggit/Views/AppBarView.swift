//
//  AppBarView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/11/25.
//

import SwiftUI

struct AppBarView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var isHomeView: Bool
    var title: String?
    var buttonImage: String?
    var action: (() -> Void)?
    
    init(isHomeView: Bool, title: String? = nil, buttonImage: String? = nil, action: (() -> Void)? = nil) {
        self.isHomeView = isHomeView
        
        if !isHomeView {
            precondition(title != nil, "isHomeView가 false일 때 title을 반드시 입력해야 함.")
            precondition(buttonImage != nil, "isHomeView가 false일 때 buttonImage를 반드시 입력해야 함.")
            precondition(action != nil, "isHomeView가 false일 때 action을 반드시 입력해야 함")
        }
        
        self.title = title
        self.buttonImage = buttonImage
        self.action = action
    }
    
    var body: some View {
        HStack {
            if isHomeView {
                Image("appLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
            }
            else {
                Button(action: {
                    router.back()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.primaryWhite)
                        .scaledToFit()
                        .frame(height: 15)
                }
                Text(title ?? "")
                    .textStyle(.b117SB)
                    .foregroundStyle(Color.primaryWhite)
                    .padding(.leading, 5.5)
            }
            
            Spacer()
            
            Button(action: action ?? {router.toNamed("/mypageView")}) {
                Image(buttonImage ?? "mypage")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
    }
}
