//
//  CalendarCellView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI

struct CalendarCellView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    let day: Int?
    let size: CGFloat?
    let codeCommitCount: Int?
    let blogCommitCount: Int?
    
    var body: some View {
        VStack(spacing: 4) {
            if let day = day,
               let _ = codeCommitCount,
               let _ = blogCommitCount {
                Button(action: {
                    // 날짜 클릭 액션 구현
                }) {
                    Rectangle()
                        .frame(width: 29, height: 29)
                        .foregroundColor(.clear)
                        .background(cellBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 4.55))
                }
                Text("\(day)")
                    .font(.caption)
                    .foregroundColor(.white)
            } else {
                // 빈 칸 처리
                Rectangle()
                    .frame(width: size, height: size)
                    .foregroundColor(.clear)
                Text("")
            }
        }
    }
    
    // 상대적 계산을 위한 함수: 색상을 반환
    func colorForCommitCount(count: Int, maxCount: Int, palette: [Color]) -> Color {
        guard maxCount > 0 else { return palette.first ?? Color.clear }
        let ratio = CGFloat(count) / CGFloat(maxCount)
        // 팔레트의 인덱스는 0부터 (palette.count - 1)까지로 비율에 따라 결정
        let index = min(Int(ratio * CGFloat(palette.count - 1)), palette.count - 1)
        return palette[index]
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
