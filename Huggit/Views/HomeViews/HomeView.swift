
import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    let horizontalPadding: CGFloat = 21
    var calendarHeight: CGFloat {
        let totalCells = homeViewModel.calendarViewModel.daysInMonthWithPadding.count
        let numberOfRows = ceil(Double(totalCells) / 7.0)
        let rowHeight = 41.0
        let rowPadding = 12.0
        let dateGridHeight = (rowHeight * numberOfRows) + (rowPadding * (numberOfRows - 1))
        let calendarHeaderHeight = 25.0
        let vStackPadding = 27.0
        let dayHeaderHeight = 11.0
        let dayHeaderPadding = 15.0
        return calendarHeaderHeight + vStackPadding + dayHeaderHeight + dayHeaderPadding + dateGridHeight
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView(.vertical) {
                    VStack {
                        HomeHeaderView()
                        CalendarView { cellInfo in
                            let containerFrame = geometry.frame(in: .global)
                            homeViewModel.commitDetailViewModel.updateSelection(
                                cellFrame: cellInfo.frame,
                                containerFrame: containerFrame,
                                day: cellInfo.day ?? 1,
                                horizontalPadding: horizontalPadding
                            )
                        }
                        .frame(height: calendarHeight)
                        .padding(.top, 49)
                        
                        CommitListView()
                            .padding(.top, 53)
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                .refreshable {
                    homeViewModel.loadAllData()
                }
                
                // CommitDetailView
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
                // CommitCreateView
                if homeViewModel.commitCreateViewModel.selectedCommit != nil {
                        // 배경 터치 시 CommitCreateView 닫힘
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                homeViewModel.commitCreateViewModel.cancelCommit()
                            }
                        
                        CommitCreateView()
                            .frame(width: geometry.size.width * 0.9, height: 300)
                            .background(Color.white)
                            .cornerRadius(12)
                    
                }
            }
            .environmentObject(homeViewModel)
            .navigationBarHidden(true)
        }
    }
}
