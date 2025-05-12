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
    
    // 오늘에 해당 하는 셀인지
    var isToday: Bool {
        guard let day = day else { return false }
        let current = Date()
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: current)
        let currentMonth = calendar.component(.month, from: current)
        let currentYear = calendar.component(.year, from: current)
        
        return (day == currentDay) &&
        (calendarViewModel.currentMonth == currentMonth) &&
        (calendarViewModel.currentYear == currentYear)
    }
    
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 4.55)
                                    .stroke(isToday ? Color.noticGreen : Color.clear, lineWidth: 1)
                            )
                    }
                    Text("\(day)")
                        .font(.caption)
                        .foregroundColor(isToday ? Color.noticGreen : Color.gray000)
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
        // commit count가 0이면 무조건 첫 번째 색상 반환
        if count == 0 {
            return palette[0]
        }
        
        // 최대값이 1 이하인 경우, commit이 있는 날이면 두 번째 색상 반환 (palette에 두 번째 색상이 있는지 확인)
        if maxCount <= 1 {
            return palette.count > 1 ? palette[1] : palette[0]
        }
        
        // count가 1 이상이고 maxCount가 2 이상인 경우 비율에 따라 색상을 선택
        let adjustedMax = maxCount - 1
        let adjustedCount = count - 1
        let ratio = CGFloat(adjustedCount) / CGFloat(adjustedMax)
        let index = 1 + min(Int(ratio * CGFloat(palette.count - 1)), palette.count - 2)
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
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading
                )
            )
        }
    }
}
