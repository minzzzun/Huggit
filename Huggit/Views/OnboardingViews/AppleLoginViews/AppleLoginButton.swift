import SwiftUI
import AuthenticationServices


struct AppleLoginButton: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = AppleLoginViewModel()
    
    var body: some View {

        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                viewModel.handleAppleSignIn(result: result)
            }
        )
        .frame(width: UIScreen.main.bounds.width - 40)
        .frame(height: 64)
        .cornerRadius(8)
        .onChange(of: viewModel.isAuthenticated) { newValue in
            if newValue {
                print("loginRouteStack: \(router.loginRouteStack)")
                let nextRoute = router.popNextLoginRoute()
                if nextRoute == "/" {
                    router.offAll(nextRoute)
                }
                else {
                    router.toNamed(nextRoute)
                }
            }
        }
    }
}
