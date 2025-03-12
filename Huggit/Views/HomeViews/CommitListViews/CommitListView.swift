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
            (
                Text("오늘 ")
                    .foregroundStyle(.white)
                + Text("\(commitListViewModel.commitList.count)개의 ")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                + Text("커밋 내역이 있어요!")
                    .foregroundStyle(.white)
            )
            .font(.system(size: 16))
            
            VStack(spacing: 16) {
                ForEach(commitListViewModel.sortedCommitList, id: \.id) { commit in
                    CommitListCellView(commit: commit)
                }
            }
            .padding(.top, 20)
        }
    }
}
