//
//  ProgressView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

//import SwiftUI
//
//struct ProgressView: View {
//    var currentCommitDays: Int
//    var daysInThisMonth: Int
//    
//    var body: some View {
//        VStack (alignment: .leading){
//            Text("오늘도 1일 1커밋을 향해!")
//                .font(.system(size: 14))
//                .foregroundStyle(.white)
//                .padding(.bottom, 22)
//            
//            GeometryReader { geometry in
//                // 전체 길이 대비 진행률 계산
//                let ratio = CGFloat(currentCommitDays) / CGFloat(daysInThisMonth)
//                let clampedRatio = min(max(ratio, 0), 1)
//                let progressWidth = geometry.size.width * clampedRatio
//                
//                ZStack(alignment: .leading) {
//                    // 전체 배경 바
//                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
//                        .fill(Color(hex: "2A2A2A"))
//                    
//                    // 진행된 부분
//                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [.blueMore, .greenMore]),
//                                startPoint: .leading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .frame(width: progressWidth)
//                    
//                    // 툴팁
//                    Image("tooltip")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 41, height: 29.1)
//                        .offset(x: progressWidth - (41/2), y: -40)
//                }
//            }
//            .frame(height: 11)
//        }
//        .frame(maxWidth: .infinity, maxHeight: 135)
//    }
//}
