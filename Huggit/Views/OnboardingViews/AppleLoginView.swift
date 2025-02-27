import SwiftUI


struct AppleLoginView : View {
    @EnvironmentObject var router : NavigationRouter
    @State private var isAppleLogined = false  // 애플 로그인 여부
    
    var body: some View {
        VStack {

            AppleLoginButton()
            
        }
        .frame(height: UIScreen.main.bounds.height)
        
    }
}


#Preview {
    AppleLoginView()
}
