
import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some View {
        VStack {
            ProgressView()
            CalendarView() 
        }
        .environmentObject(homeViewModel)
        .background(Color.black)
    }
}
