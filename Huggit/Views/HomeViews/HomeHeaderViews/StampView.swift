import SwiftUI

struct StampView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var HomeHeaderViewModel: HomeHeaderViewModel { homeViewModel.homeHeaderViewModel }
    
    var body: some View {
        VStack(alignment: .trailing) {
            Tooltip {
                Text(HomeHeaderViewModel.tooltipText)
                    .foregroundStyle(Color.gray000)
                    .textStyle(.d39M)
                    .padding(.top, 7)
            }
            
            HStack {
                Image(HomeHeaderViewModel.stampName(for: 1))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(0)
                
                Image(HomeHeaderViewModel.stampName(for: 2))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .padding(.leading, -20.1)
                    .padding(.trailing, 0)
                
                Image(HomeHeaderViewModel.stampName(for: 3))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 63, height: 63)
                    .padding(.leading, -24.2)
                    .padding(.trailing, 0)
                    .shadow(color: Color.white.opacity(0.8), radius: 12.6)
            }
            .padding(.top, 6.85)
        }
    }
}
