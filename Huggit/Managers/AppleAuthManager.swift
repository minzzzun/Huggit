//
//  AppleAuthManager.swift
//  Huggit
//
//  Created by 김민준 on 6/27/25.
//

import Foundation
import AuthenticationServices
import Combine

enum AppleAuthError: Error {
    case invalidClientId
    case invalidClientSecret
    case networkError(Error)
    case invalidResponse
    case tokenRevocationFailed
    case missingToken
    case invalidToken
    case loginFailed(Error)
}


final class AppleAuthManager: ObservableObject {
    static let shared = AppleAuthManager()
    private init() {}
    
    @Published var isAuthenticated = false
    
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
                
                // 토큰 정보 가져오기 및 저장
                if let identityToken = appleIDCredential.identityToken,
                   let identityTokenString = String(data: identityToken, encoding: .utf8) {
                    UserInfo.appleIdentityToken = identityTokenString
                    print("Apple Identity Token 저장됨")
                }
                
                if let authorizationCode = appleIDCredential.authorizationCode,
                   let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) {
                    UserInfo.appleAuthorizationCode = authorizationCodeString
                    self.getRefreshtoken(authorizationCodeString){ result in
                        switch result {
                        case .success:
                            print("리프레시 토큰 저장됨 \(UserInfo.appleRefreshToken)")
                        case .failure(let err):
                            print(err)
                        }
                        
                    }
                    print("Apple Authorization Code 저장됨")
                }
                
                // UserDefaults에 저장
                UserInfo.appleId = appleId
                print("Apple ID 저장됨: \(appleId)")
                
                // 인증 상태 업데이트
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
                
            default:
                print("Apple ID Credential이 아닙니다.")
            }
        case .failure(let error):
            print("Apple Login Failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        }
    }
    
    //MARK: - refresh token 얻기
    private func getRefreshtoken(
            _ code: String,
            completion: @escaping (Result<Void, AppleAuthError>) -> Void
        ) {
            guard let clientId = AppleConfig.clientId, !clientId.isEmpty else {
                return completion(.failure(.invalidClientId))
            }
            guard let clientSecret = AppleConfig.clientSecret, !clientSecret.isEmpty else {
                return completion(.failure(.invalidClientSecret))
            }
            
            let url = URL(string: "https://appleid.apple.com/auth/token")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let params: [String: String] = [
                "client_id": clientId,
                "client_secret": clientSecret,
                "code": code,
                "grant_type": "authorization_code"
            ]
            request.httpBody = encodeForm(params).data(using: .utf8)
            
            print("Authorization Code 교환 요청 시작...")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let err = error {
                        print("네트워크 에러: \(err)")
                        return completion(.failure(.networkError(err)))
                    }
                    guard let http = response as? HTTPURLResponse, let data = data else {
                        return completion(.failure(.invalidResponse))
                    }
                    
                    print("토큰 교환 응답: HTTP \(http.statusCode)")
                    
                    if http.statusCode == 200 {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let refresh = json["refresh_token"] as? String {
                                UserInfo.appleRefreshToken = refresh
                                print("✅ Refresh Token 교환 성공")
                                completion(.success(()))
                            } else {
                                print("❌ Refresh Token이 응답에 없습니다")
                            }
                        } catch {
                            print("❌ JSON 파싱 에러: \(error)")
                        }
                    } else {
                        let detail = String(data: data, encoding: .utf8) ?? "HTTP \(http.statusCode)"
                        print("❌ 토큰 교환 실패: \(detail)")
                    }
                }
            }.resume()
        }


// MARK: - Apple 토큰 해지 (회원탈퇴)
func revokeAppleToken(completion: @escaping (Result<Void, AppleAuthError>) -> Void) {
    print(#fileID,#function,#line, "")
    guard let clientId = AppleConfig.clientId,
          let clientSecret = AppleConfig.clientSecret,
          !UserInfo.appleRefreshToken.isEmpty else {
        completion(.failure(.missingToken))
        return
    }
    
    guard let url = URL(string: "https://appleid.apple.com/auth/revoke") else {
        completion(.failure(.invalidResponse))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let params: [String: String] = [
        "client_id": clientId,
        "client_secret": clientSecret,
        "token": UserInfo.appleRefreshToken,
        "token_type_hint": "refresh_token"
    ]
    
    print(#fileID,#function,#line, "여기야 여기")
    print(clientId)
    print(clientSecret)
    print("\n\n")
    print(UserInfo.appleRefreshToken)
    
    request.httpBody = encodeForm(params).data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(.networkError(error)))
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                print("Apple 토큰 해지 성공")
                completion(.success(()))
            } else {
                print("Apple 토큰 해지 실패: HTTP \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("응답 내용: \(responseString)")
                }
                completion(.failure(.tokenRevocationFailed))
            }
        } else {
            completion(.failure(.invalidResponse))
        }
    }.resume()
}

// 헬퍼 메서드
private func encodeForm(_ dict: [String: String]) -> String {
    print(#fileID,#function,#line, "")
    return dict.map { key, value in
        let k = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let v = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return "\(k)=\(v)"
    }
    .joined(separator: "&")
}

// MARK: - 로그아웃
func logout(completion: @escaping () -> Void) {
    // 로그아웃 시에는 Apple ID만 삭제 (토큰은 유지)
    print(#fileID,#function,#line, "")
    UserInfo.appleId = ""
    print("로그아웃 완료: appleId가 삭제되었습니다.")
    
    DispatchQueue.main.async {
        self.isAuthenticated = false
        completion()
    }
}

// MARK: - 회원탈퇴 (모든 데이터 삭제 + 토큰 해지)
func deleteAccount(completion: @escaping () -> Void) {
    print(#fileID,#function,#line, "")
    // Apple 토큰 해지 시도
    revokeAppleToken { result in
        switch result {
        case .success:
            print("Apple 토큰 해지 성공")
        case .failure(let error):
            print("Apple 토큰 해지 실패: \(error)")
            // 토큰 해지가 실패해도 로컬 데이터는 삭제
        }
        
        // UserDefaults의 모든 데이터 삭제
        UserInfo.appleId = ""
        UserInfo.appleIdentityToken = ""
        UserInfo.appleAuthorizationCode = ""
        UserInfo.appleRefreshToken = ""
        UserInfo.gitLogin = ""
        UserInfo.gitName = ""
        UserInfo.gitEmail = ""
        UserInfo.repoName = ""
        UserInfo.githubAccessToken = ""
        UserInfo.tistoryName = ""
        UserInfo.velogName = ""
        
        print("회원탈퇴 완료: 모든 사용자 데이터가 삭제되었습니다.")
        
        DispatchQueue.main.async {
            self.isAuthenticated = false
            completion()
        }
    }
}

// MARK: - 인증 상태 확인
func checkAuthenticationStatus() {
    DispatchQueue.main.async {
        self.isAuthenticated = !UserInfo.appleId.isEmpty
    }
}

}
