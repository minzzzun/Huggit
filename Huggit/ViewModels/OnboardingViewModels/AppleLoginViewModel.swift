import SwiftUI
import AuthenticationServices


class AppleLoginViewModel: ObservableObject {
    @Published var isAuthenticated = false
    let defaults = UserDefaults.standard
    
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            print("Apple Login Successful")
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                // 계정 정보 가져오기
                let appleId = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                
                // UserDefaults에 저장
                defaults.set(appleId, forKey: "appleId")
                print("uid 저장됨 \(appleId)")
                
                // 인증 상태 업데이트
                isAuthenticated = true
                
            default:
                break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("error")
        }
    }
}
