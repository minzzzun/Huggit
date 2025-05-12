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
                .textStyle(.c114R)
                .foregroundStyle(Color.primaryWhite)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.leading, 20)
            Spacer()
            Button(action: {
                commitListViewModel.selectedCommit = commit
            }) {
                Text("commit")
                    .textStyle(.b213R)
                    .foregroundColor(Color.primary)
            }
            .frame(width: 62, height: 28)
            .background(Color.gray300)
            .cornerRadius(6)
            .padding(.leading, 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        
        .frame(maxWidth: .infinity, maxHeight: 67)
        .background(Color.gray500)
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
