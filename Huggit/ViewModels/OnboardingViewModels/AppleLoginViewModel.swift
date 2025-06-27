import SwiftUI
import AuthenticationServices


class AppleLoginViewModel: ObservableObject {
    @Published var isAuthenticated = false
    
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            print("Apple Login Successful")
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                // 계정 정보 가져오기
                let appleId = appleIDCredential.user
                _ = appleIDCredential.fullName
                _ = appleIDCredential.email
                _ = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                _ = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                
                // UserDefaults에 저장
                UserInfo.appleId = appleId
            
                // 인증 상태 업데이트
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
                
            default:
                break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("error")
        }
    }
}
