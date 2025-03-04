//
//  CommitDetailSectionView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct CommitDetailSectionView: View {
    
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 3)
                .background(Color(hex:"313138"))
            VStack(alignment: .leading) {
                // Repo
                Text("Mumuk")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                
                // Commit Message -> 나중에 ForEach로 바꿀 것
                VStack(spacing: 3) {
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .foregroundStyle(.blue)
                        Text("머먹 온보딩")
                            .font(.system(size: 12))
                            .foregroundStyle(.blue)
                            .padding(.leading, 5)
                    }
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .foregroundStyle(.blue)
                        Text("머먹 온보딩")
                            .font(.system(size: 12))
                            .foregroundStyle(.blue)
                            .padding(.leading, 5)
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.vertical, 1)
            Spacer()
        }
    }
}

#Preview {
    CommitDetailSectionView()
}
