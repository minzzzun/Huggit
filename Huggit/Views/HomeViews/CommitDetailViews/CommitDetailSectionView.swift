//
//  CommitDetailSectionView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct CommitDetailSectionView: View {
    var repoName: String
    var commitMessages: [String]
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 3)
                .foregroundStyle(Color.gray400)
            
            VStack(alignment: .leading) {
                // Repo
                Text(repoName)
                    .textStyle(.c514SB)
                    .foregroundStyle(Color.gray000)
                
                // Commit Message
                ForEach(Array(commitMessages.enumerated()), id: \.offset) { index, message in
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .foregroundStyle(Color.semiBlue)
                        Text(message)
                            .textStyle(.c312R)
                            .foregroundStyle(Color.semiBlue)
                            .padding(.leading, 5)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.vertical, 1)
            Spacer()
        }
    }
}
