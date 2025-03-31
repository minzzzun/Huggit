import SwiftUI

class GithubLoginViewModel: ObservableObject {
    @Published var accessToken : String? = nil
    @Published var isAuthenticated: Bool = false
    @Published var isLoggingIn: Bool = false
    
    let clientId = GitHubConfig.client_id
    let clientSecret = GitHubConfig.client_secret
    
    //MARK: - 1. 깃허브에서 code 받아오기
    func requestCode() {
        isLoggingIn = true
        GithubAuthManager.shared.requestCode()
    }
    
    //MARK: - 2. 받아온 code로 Token 받기
    func requestAccessToken(code: String) {
        GithubAuthManager.shared.requestAccessToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self?.accessToken = token
                    UserInfo.githubAccessToken = token
                    self?.fetchGithubUser()
                    self?.createRepository {
                        self?.isAuthenticated = true
                        self?.isLoggingIn = false
                    }
                case .failure(let error):
                    print("Access token 요청 실패: \(error)")
                }
            }
        }
    }
    
    func fetchGithubUser() {
        GithubUserManager.shared.fetchUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserInfo.gitLogin = user.login
                    UserInfo.gitName = user.name ?? user.login
                    if let email = user.email {
                        UserInfo.gitEmail = email
                        print("이메일 (/user): \(email)")
                    } else {
                        self.fetchGithubUserEmails()
                    }
                    print("GitHub 사용자 정보 업데이트 완료")
                case .failure(let error):
                    print("Error fetching GitHub user: \(error)")
                }
            }
        }
    }
    
    // MARK: GitHub 이메일 가져오기
    func fetchGithubUserEmails() {
        GithubUserManager.shared.fetchUserEmails { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let emails):
                    if let primary = emails.first(where: { $0.primary }) {
                        UserInfo.gitEmail = primary.email
                        print("이메일 (/user/emails, primary): \(primary.email)")
                    } else if let first = emails.first {
                        UserInfo.gitEmail = first.email
                        print("이메일 (/user/emails, 첫번째): \(first.email)")
                    } else {
                        print("이메일 정보를 찾을 수 없습니다.")
                    }
                case .failure(let error):
                    print("이메일 가져오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: - 레포 생성하기
    func createRepository(completion: @escaping () -> Void) {
        guard let accessToken = self.accessToken else {
            print("🚨 토큰 없음")
            completion()
            return
        }
        
        GithubRepoManager.shared.createRepositoryIfNeeded(accessToken: accessToken,
                                                          description: "Test repository",
                                                          isPrivate: false) { result in
            switch result {
            case .success(let repository):
                UserInfo.repoName = UserInfo.defaultRepoName
                print("리포지토리 생성(또는 기존 레포 사용) 성공: \(String(describing: repository.name))")
            case .failure(let error):
                print("리포지토리 생성 실패: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
