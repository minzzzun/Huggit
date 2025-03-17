//
//  FeedbackView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/12/25.
//

import SwiftUI

struct FeedbackView: View {
    var body: some View {
        HStack (spacing: 7) {
            VStack {
                (
                    Text("허깃은 여러분의 목소리로\n")
                        .foregroundStyle(.white)
                    + Text("더 나은 서비스")
                        .foregroundStyle(.blue)
                    + Text("를 만들어가요!")
                        .foregroundStyle(.white)
                )
                .font(.system(size: 15))
            }
            Spacer()
            Image("feedback")
                .resizable()
                .scaledToFit()
                .frame(width: 73, height: 73)
            Image(systemName: "chevron.right")
                .foregroundStyle(.white)
                .scaledToFit()
                .frame(height: 8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.gray)
        )
        .onTapGesture {
            // TODO: 피드백 폼 연결
        }
    }
}
