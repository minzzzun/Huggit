//
//  MyPageView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/11/25.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                AppBarView(
                    isHomeView: false,
                    title: "마이페이지",
                    buttonImage: "house",
                    action: {
                        router.offAll("/")
                    }
                )
                Text("My Page")
            }
            .padding(.horizontal, 21)
        }
        .background(.black)
        .navigationBarHidden(true)
    }
}
