
import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some View {
        VStack {
            HomeHeaderView()
            CalendarView()
        }
        .environmentObject(homeViewModel)
        .background(Color.black)
        .padding(.horizontal, 21)
    }
}
