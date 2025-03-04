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
    
    var body: some View {
        Tooltip(width: tooltipWidth, height: tooltipHeight, cornerRadius: 5, arrowHeight: arrowHeight, arrowPosition: arrowPosition, arrowTipRadius: 2, color: Color(hex: "1F2125"), arrowDirection: .up) {
            VStack {
                HStack (alignment: .top) {
                    (
                        Text("2025년 2월 8일에는 \n총 ")
                            .foregroundStyle(.white)
                        + Text("5개")
                            .foregroundStyle(.green)
                        + Text("의 커밋을 했어요!")
                            .foregroundStyle(.white)
                    )
                    .font(.system(size: 15))
                    Spacer()
                    Button(action: {
                        commitDetailViewModel.clearSelection()
                    }) {
                        ZStack {
                            Image(systemName: "x.circle.fill")
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.bottom, 10)
                ScrollView(.vertical) {
                    // TODO: ForEach로 repo 값 보내기
                    VStack (spacing: 20) {
                        CommitDetailSectionView()
                        CommitDetailSectionView()
                    }
                    .padding(.top, 10)
                }
            }
            .padding(20)
        }
    }
}
