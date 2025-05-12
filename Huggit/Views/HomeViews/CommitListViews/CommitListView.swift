//
//  CommitListView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/7/25.
//

import SwiftUI

struct CommitListView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var commitListViewModel: CommitListViewModel {
        homeViewModel.commitListViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("오늘 ")
                    .foregroundStyle(Color.primaryWhite)
                    .textStyle(.d415R)
                Text("\(commitListViewModel.commitList.count)개")
                    .foregroundStyle(Color.primaryWhite)
                    .textStyle(.d515B)
                Text("의 잔디를 심을 수 있어요!")
                    .foregroundStyle(Color.primaryWhite)
                    .textStyle(.d415R)
            }
            .font(.system(size: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                ForEach(commitListViewModel.sortedCommitList, id: \.id) { commit in
                    CommitListCellView(commit: commit)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: commitListViewModel.commitList)

            .padding(.top, 20)
        }
    }
}
