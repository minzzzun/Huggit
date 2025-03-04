//
//  CalendarCellView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI

struct CalendarCellView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var calendarViewModel: CalendarViewModel {
        homeViewModel.calendarViewModel
    }
    
    let day: Int?
    let size: CGFloat?
    let codeCommitCount: Int?
    let blogCommitCount: Int?
    
    let onSelect: (CGRect) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 4) {
                if let day = day,
                   let _ = codeCommitCount,
                   let _ = blogCommitCount {
                    Button(action: {
                        let frame = geometry.frame(in: .global)
                        onSelect(frame)
                    }) {
                        Rectangle()
                            .frame(width: size, height: size)
                            .foregroundColor(.clear)
                            .background(cellBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 4.55))
                    }
                    Text("\(day)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(height: 8)
                } else {
                    // 빈 칸 처리
                    Rectangle()
                        .frame(width: size, height: size)
                        .foregroundColor(.clear)
                    Text("")
                        .frame(height: 8)
                }
            }
        }
        .frame(width: size, height: 41)
    }
    
    // 상대적 계산을 위한 함수: 색상을 반환
    func colorForCommitCount(count: Int, maxCount: Int, palette: [Color]) -> Color {
        // maxCount가 1 이하인 경우 안전하게 첫 번째 색상 반환
        guard maxCount > 1 else { return palette.first ?? Color.clear }
        
        // count가 0이면 무조건 첫 번째 단계 반환
        if count == 0 {
            return palette[0]
        } else {
            // count > 0인 경우, 1~maxCount를 1부터 palette.count-1까지 매핑
            let adjustedMax = maxCount - 1  // 최대 범위 조정
            let adjustedCount = count - 1   // 최소 값 1을 0부터 시작하도록 조정
            let ratio = CGFloat(adjustedCount) / CGFloat(adjustedMax)
            // index는 1부터 시작하여 palette.count-1까지
            let index = 1 + min(Int(ratio * CGFloat(palette.count - 1)), palette.count - 2)
            return palette[index]
        }
    }
    
    // 셀 배경 반환
    var cellBackground: some View {
        let codeCount = codeCommitCount ?? 0
        let blogCount = blogCommitCount ?? 0
        
        let greenPalette: [Color] = [.greenLess, .greenLow, .greenMedium, .greenHigh, .greenMore]
        let bluePalette: [Color] = [.blueLess, .blueLow, .blueMedium, .blueHigh, .blueMore]
        
        switch calendarViewModel.currentGrass {
        case .codeGrass:
            let maxCode = calendarViewModel.maxCodeCommitCount
            let codeColor = colorForCommitCount(count: codeCount, maxCount: maxCode, palette: greenPalette)
            return AnyView(codeColor)
            
        case .blogGrass:
            let maxBlog = calendarViewModel.maxBlogCommitCount
            let blogColor = colorForCommitCount(count: blogCount, maxCount: maxBlog, palette: bluePalette)
            return AnyView(blogColor)
            
        case .allGrass:
            let maxCode = calendarViewModel.maxCodeCommitCount
            let maxBlog = calendarViewModel.maxBlogCommitCount
            let codeColor = colorForCommitCount(count: codeCount, maxCount: maxCode, palette: greenPalette)
            let blogColor = colorForCommitCount(count: blogCount, maxCount: maxBlog, palette: bluePalette)
            return AnyView(
                LinearGradient(
                    gradient: Gradient(colors: [codeColor, blogColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
}
