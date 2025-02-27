import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    @EnvironmentObject  var router : NavigationRouter
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    switch authResults.credential{
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // 계정 정보 가져오기
                        let UserIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let email = appleIDCredential.email
                        let IdentityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                        let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                        
                        print("UserIdentifier : \(UserIdentifier)")
                        print("fullName :\(fullName)")
                        print("email : \(email)")
                        print("IdentityToken : \(IdentityToken)")
                        print("AuthorizationCode : \(AuthorizationCode)")
                        
                        //애플 로그인 성공시 깃헙로그인 페이지로 이동
                        router.toNamed("/githublogin")
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        )
        .frame(width : UIScreen.main.bounds.width * 0.9, height:50)
        .cornerRadius(5)
        
    }
}
