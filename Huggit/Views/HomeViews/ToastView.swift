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
                    .textStyle(.s114M)
                    .foregroundColor(Color.gray000)
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 13)
            .background(Color.gray600)
            .clipShape(Capsule())
            .padding(.bottom, 20)
        }
        .shadow(color: Color.primaryWhite.opacity(0.2), radius: 13, x: 0, y: 0)
        .allowsHitTesting(false)
    }
}
