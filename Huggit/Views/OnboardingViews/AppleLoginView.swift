import SwiftUI


struct AppleLoginView : View {
    @EnvironmentObject var router : NavigationRouter
    
    var body: some View {
        VStack {
            AppleLoginButton()
        }
        .navigationBarHidden(true)
        .frame(height: UIScreen.main.bounds.height)
        
    }
}


#Preview {
    AppleLoginView()
}
