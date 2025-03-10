import SwiftUI

class GithubLoginViewModel: ObservableObject {
    @Published var accessToken : String? = nil
    let clientId = GitHubConfig.client_id
    let clientSecret = GitHubConfig.client_secret
    
    let defaults = UserDefaults.standard
    
    //MARK: - 1. 깃허브에서 code 받아오기
    func requestCode() {
        print(#fileID,#function,#line, "")
        let scope = "repo,user"
        
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientId)&scope=\(scope)"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
        }
    }
    
    
    //MARK: - 2. 받아온 code로 Token 받기
    func requestAccessToken(code: String) {
        print(#fileID, #function, #line, "")
       
        let url = URL(string: "https://github.com/login/oauth/access_token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // 추가
        
        let body: [String: String] = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code
        ]
        
        print("📤 요청 Body:", body)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("📡 응답 받음")
            
            if let error = error {
                print("❌ 네트워크 에러:", error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP 상태 코드:", httpResponse.statusCode)
                
                // 헤더 디버깅
                print("🔍 응답 헤더:")
                httpResponse.allHeaderFields.forEach { key, value in
                    print("   \(key): \(value)")
                }
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("📦 응답 데이터:", responseString)
            } else {
                print("❌ 응답 데이터가 없거나 읽을 수 없음")
            }
            
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("🔍 파싱된 JSON:", json)
                
                if let token = json["access_token"] as? String {
                    DispatchQueue.main.async {
                        self.accessToken = token
                        self.defaults.set(self.accessToken, forKey: "githubAccessToken")
                        print("✅ GitHub Access Token:", token)
                        
                        let gitToken = UserDefaults.standard.string(forKey: "githubAccessToken")
                        let appleId = self.defaults.string(forKey: "appleId")
                        print("appleId 저장됨: \(appleId)")
                        print("gitToken 저장됨: \(gitToken)")
//                        self.getUser() // 토큰을 받은 후 사용자 정보 요청
//                        self.getRepos()
                        self.createRepository()

                    }
                } else {
                    print("❌ access_token이 응답에 없음")
                }
            } else {
                print("❌ JSON 파싱 실패")
            }
        }.resume()
    }
    
  
    //MARK: - 레포 생성하기
    func createRepository() {
        guard let accessToken = self.accessToken else {
            print("🚨토큰 없음 ")
            return
        }
    
        GithubRepoManager.shared.createRepository(accessToken: accessToken, name: "NewRepo1", description: "Test repository", isPrivate: false) { result in
            switch result {
            case .success(let repository):
                print("리포지토리 생성 성공: \(repository.name)")
            case .failure(let error):
                print("리포지토리 생성 실패: \(error.localizedDescription)")
            }
        }

    }
    
    
    
    
    
}
