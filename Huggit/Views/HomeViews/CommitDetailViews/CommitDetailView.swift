//
//  CommitDetailView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct CommitDetailView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var commitDetailViewModel: CommitDetailViewModel {
        homeViewModel.commitDetailViewModel
    }
    
    let arrowPosition: CGFloat
    let arrowHeight: CGFloat
    let tooltipWidth: CGFloat
    let tooltipHeight: CGFloat
    let arrowDirection: ArrowDirection
    
    var body: some View {
        Tooltip(width: tooltipWidth,
                height: tooltipHeight,
                cornerRadius: 10,
                arrowHeight: arrowHeight,
                arrowPosition: arrowPosition,
                arrowTipRadius: 2,
                color: Color.gray600,
                arrowDirection: arrowDirection) {
            VStack {
                HStack(alignment: .top) {
                    (
                        Text("\(String(commitDetailViewModel.selectedYear))년 \(commitDetailViewModel.selectedMonth)월 \(commitDetailViewModel.selectedDay)일에는 \n총 ")
                            .foregroundStyle(Color.primaryWhite)
                        + Text("\(commitDetailViewModel.totalContributionCount)개")
                            .foregroundStyle(Color.noticGreen)
                            .foregroundStyle(Color.noticGreen)
                        + Text("의 커밋을 했어요!")
                            .foregroundStyle(Color.primaryWhite)
                    )
                    .textStyle(.h615M)
                    Spacer()
                    Button(action: {
                        commitDetailViewModel.clearSelection()
                    }) {
                        ZStack {
                            Image("cancel")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                        }
                    }
                }
                .padding(.bottom, 10)
                
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        ForEach(commitDetailViewModel.contributionDetails, id: \.repositoryName) { detail in
                            CommitDetailSectionView(repoName: detail.repositoryName,
                                                    commitMessages: detail.messages)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.bottom, 10)
            }
            .padding(20)
        }
                .onAppear {
                    if let details = commitDetailViewModel.contributionDetailsByDay[commitDetailViewModel.selectedDay] {
                        commitDetailViewModel.contributionDetails = commitDetailViewModel.filterContributionDetails(details)
                    }
                }
    }
}
