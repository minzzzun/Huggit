import SwiftUI

class GithubLoginViewModel: ObservableObject {
    @Published var accessToken : String? = nil
    let clientId = GitHubConfig.client_id
    let clientSecret = GitHubConfig.client_secret
    
    let defaults = UserDefaults.standard
    // 1. 깃허브에서 code 받아오기
    func requestCode() {
        print(#fileID,#function,#line, "")
        let scope = "repo,user"
        
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientId)&scope=\(scope)"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
        }
    }
    
    
    // 2. 받아온 code로 Token 받기
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
                    }
                } else {
                    print("❌ access_token이 응답에 없음")
                }
            } else {
                print("❌ JSON 파싱 실패")
            }
        }.resume()
    }
    
    
    func getUser() {
        print(#fileID,#function,#line, "")
        guard let accessToken = self.accessToken else {
            print("❌ 액세스 토큰이 없습니다.")
            return
        }
        
        let url = URL(string: "https://api.github.com/user")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 네트워크 에러: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("❌ 서버 응답 에러: \(response.debugDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ 데이터 없음")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("✅ 사용자 정보:")
                    print("이름: \(json["name"] as? String ?? "이름 없음")")
                    print("로그인: \(json["login"] as? String ?? "로그인 정보 없음")")
                    print("이메일: \(json["email"] as? String ?? "이메일 없음")")
                    print("프로필 URL: \(json["html_url"] as? String ?? "URL 없음")")
                    print("전체 정보: \(json)")
                }
            } catch {
                print("❌ JSON 파싱 에러: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    
    //MARK: - repo 가져오기
    
    func getRepos() {
        print(#fileID, #function, #line, "")
        guard let accessToken = self.accessToken else {
            print("❌ 액세스 토큰이 없습니다.")
            return
        }
        
        let url = URL(string: "https://api.github.com/user/repos?per_page=100")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 네트워크 에러: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("❌ 서버 응답 에러: \(response?.description ?? "알 수 없는 오류")")
                return
            }
            
            guard let data = data else {
                print("❌ 데이터 없음")
                return
            }
            
            do {
                if let repositories = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    print("✅ 저장소 목록:")
                    for (index, repo) in repositories.enumerated() {
                        let name = repo["name"] as? String ?? "이름 없음"
                        let fullName = repo["full_name"] as? String ?? "전체 이름 없음"
                        let htmlURL = repo["html_url"] as? String ?? "URL 없음"
                        
                        print("\(index + 1). \(name) (\(fullName))")
                        print("   URL: \(htmlURL)")
                        print("   -----------------------------")
                    }
                    print("총 \(repositories.count)개의 저장소가 있습니다.")
                } else {
                    print("❌ 저장소 목록을 파싱할 수 없습니다.")
                }
            } catch {
                print("❌ JSON 파싱 에러: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
}
