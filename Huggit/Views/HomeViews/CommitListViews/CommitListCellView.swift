//
//  CommitListCellView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/7/25.
//

import SwiftUI

struct CommitListCellView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var commitListViewModel: CommitListViewModel {
        homeViewModel.commitListViewModel
    }
    
    var commit: Post
    
    var body: some View {
        HStack {
            Image(imageName(type: commit.type))
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .clipped()
                .frame(maxHeight: .infinity)
            Text(commit.title)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.leading, 20)
            Spacer()
            Button(action: {
                commitListViewModel.selectedCommit = commit
            }) {
                Text("commit")
                    .font(.system(size: 13))
                    .foregroundColor(.white)
            }
            .frame(width: 62, height: 28)
            .background(Color.black)
            .cornerRadius(6)
            .padding(.leading, 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        
        .frame(maxWidth: .infinity, maxHeight: 67)
        .background(Color.gray)
        .cornerRadius(10)
    }
    
    func imageName(type: PostType) -> String {
        switch type {
        case .tistory:
            return "tistoryLogo"
        case .velog:
            return "velogLogo"
        }
    }
}
