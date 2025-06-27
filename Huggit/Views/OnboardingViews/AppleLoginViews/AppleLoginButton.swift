import SwiftUI
import AuthenticationServices


struct AppleLoginButton: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var appleAuthManager = AppleAuthManager.shared
    
    var body: some View {
        
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                appleAuthManager.handleAppleSignIn(result: result)
            }
        )
        .frame(width: UIScreen.main.bounds.width - 40)
        .frame(height: 64)
        .cornerRadius(8)
        .onAppear() {
            appleAuthManager.isAuthenticated = false
        }
        .onChange(of: appleAuthManager.isAuthenticated) { newValue in
            if newValue {
                router.toNamed("/githubLogin")
            }
        }
    }
}
