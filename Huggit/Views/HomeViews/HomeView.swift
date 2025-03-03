
import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var commitDetailViewModel = CommitDetailViewModel()
    
    let horizontalPadding: CGFloat = 21
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView(.vertical) {
                    VStack {
                        HomeHeaderView()
                        CalendarView()
                    }
                    .environmentObject(homeViewModel)
                    .padding(.horizontal, horizontalPadding)
                }
                
                if let cellFrame = commitDetailViewModel.selectedCellFrame {
                    let containerFrame = geometry.frame(in: .global)
                    let tooltipWidth = geometry.size.width - horizontalPadding * 2
                    let tooltipHeight = 255.0
                    let arrowPos = (cellFrame.midX - containerFrame.minX - horizontalPadding) / tooltipWidth
                    
                    // cellFrame는 글로벌 좌표이므로, 현재 GeometryReader의 좌표로 변환
                    let localCellFrame = CGRect(
                        x: cellFrame.minX - containerFrame.minX,
                        y: cellFrame.minY - containerFrame.minY,
                        width: cellFrame.width,
                        height: cellFrame.height
                    )
                    
                    // 커스텀 쉐이프를 사용하여, cell 영역을 제외한 전체 영역에 오버레이 적용
                    HoleShape(holeRect: localCellFrame)
                        .fill(Color.black.opacity(0.7), style: FillStyle(eoFill: true))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            commitDetailViewModel.clearSelection()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // CommitDetailView는 오버레이 위에 배치하여 cell과의 관계를 유지합니다.
                    CommitDetailView(arrowPosition: arrowPos,
                                     arrowHeight: 11,
                                     tooltipWidth: tooltipWidth,
                                     tooltipHeight: tooltipHeight)
                    .position(
                        x: containerFrame.midX,
                        y: localCellFrame.maxY + 9 + tooltipHeight / 2
                    )
                }
            }
            .environmentObject(commitDetailViewModel)
        }
    }
}

