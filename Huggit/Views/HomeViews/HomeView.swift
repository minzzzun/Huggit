
import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    
    let horizontalPadding: CGFloat = 21
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView(.vertical) {
                    VStack {
                        HomeHeaderView()
                        CalendarView(onCellSelect: { cellFrame in
                            let containerFrame = geometry.frame(in: .global)
                            homeViewModel.commitDetailViewModel.updateSelection(
                                cellFrame: cellFrame,
                                containerFrame: containerFrame,
                                horizontalPadding: horizontalPadding
                            )
                        })
                        .padding(.top, 49)
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                
                if let cellFrame = homeViewModel.commitDetailViewModel.selectedCellFrame {
                    let containerFrame = geometry.frame(in: .global)
                    let tooltipWidth = geometry.size.width - horizontalPadding * 2
                    let tooltipHeight = 255.0
                    let arrowPos = (cellFrame.midX - containerFrame.minX - horizontalPadding) / tooltipWidth
                    
                    let localCellFrame = CGRect(
                        x: cellFrame.minX - containerFrame.minX,
                        y: cellFrame.minY - containerFrame.minY,
                        width: cellFrame.width,
                        height: cellFrame.height
                    )
                    
                    HoleShape(holeRect: localCellFrame)
                        .fill(Color.black.opacity(0.7), style: FillStyle(eoFill: true))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            homeViewModel.commitDetailViewModel.clearSelection()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
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
            .environmentObject(homeViewModel)
        }
    }
}

