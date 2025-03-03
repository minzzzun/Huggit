//
//  CommitDetailView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct CommitDetailView: View {
    @EnvironmentObject private var commitDetailViewModel: CommitDetailViewModel
    
    var arrowPosition: CGFloat = 0.5
    var arrowHeight: CGFloat = 11
    var tooltipWidth: CGFloat = .infinity
    var tooltipHeight: CGFloat = 255
    
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
