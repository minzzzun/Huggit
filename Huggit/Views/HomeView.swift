
import SwiftUI


struct HomeView : View {
    @StateObject var viewModel = HomeViewViewModel()
    @EnvironmentObject var router : NavigationRouter
    
    var body: some View {
        VStack {
            Text("홈 뷰")
            Button(action: {
                viewModel.deleteAppleLogin()
                router.toNamed("/appleLogin")
            }){
                Text("apple로그인삭제")
            }
        }
        .navigationBarHidden(true)
        
            
    }
    
}
