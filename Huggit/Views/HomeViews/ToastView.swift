//
//  ToastView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/2/25.
//

import SwiftUI

struct ToastView: View {
    let image: String
    let message: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 10) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 13)
            .background(Color(hex: "292929"))
            .clipShape(Capsule())
            .padding(.bottom, 20)
        }
        .shadow(color: Color.white.opacity(0.25), radius: 20, x: 0, y: 0)
        .allowsHitTesting(false)
    }
}
