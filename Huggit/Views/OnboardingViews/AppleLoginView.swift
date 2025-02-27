import SwiftUI


struct AppleLoginView : View {
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
