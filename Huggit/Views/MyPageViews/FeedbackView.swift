//
//  FeedbackView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/12/25.
//

import SwiftUI

struct FeedbackView: View {
    @Environment(\.openURL) private var openURL
    private let feedbackURL = URL(string: "https://walla.my/survey/HSb9xSq6A0mDB8qewcSs")!
    
    var body: some View {
        HStack (spacing: 7) {
            VStack {
                (
                    Text("허깃은 여러분의 목소리로\n")
                        .foregroundStyle(Color.gray000)
                    + Text("더 나은 서비스")
                        .foregroundStyle(Color.primaryBlue)
                    + Text("를 만들어가요!")
                        .foregroundStyle(Color.gray000)
                )
                .font(.system(size: 15))
            }
            Spacer()
            Image("feedback")
                .resizable()
                .scaledToFit()
                .frame(width: 73, height: 73)
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.gray300)
                .scaledToFit()
                .frame(height: 8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.gray500)
        )
        .onTapGesture {
            openURL(feedbackURL)
        }
    }
}
