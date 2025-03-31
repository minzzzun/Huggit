import Foundation

final class GithubRepoManager {
    static let shared = GithubRepoManager()
    private init() {}
    
    // 지정된 이름의 레포지토리를 찾아 반환 (존재하면 해당 레포 반환, 없으면 nil)
    func findRepository(withName name: String, completion: @escaping (Result<GithubRepository?, GithubAPIError>) -> Void) {
        let endpoint = "/user/repos"
        GithubRestManager.shared.request(endpoint: endpoint,
                                           method: .GET,
                                           parameters: nil) { (result: Result<[GithubRepository], GithubAPIError>) in
            switch result {
            case .success(let repositories):
                let repo = repositories.first { ($0.name ?? "").lowercased() == name.lowercased() }
                completion(.success(repo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 리포지토리 생성: 이미 존재하면 기존 레포 반환, 없으면 새로 생성
    func createRepositoryIfNeeded(accessToken: String,
                                  description: String,
                                  isPrivate: Bool,
                                  completion: @escaping (Result<GithubRepository, GithubAPIError>) -> Void) {
        let repoName = UserInfo.defaultRepoName
        
        // 먼저, 해당 이름의 레포지토리가 존재하는지 확인
        findRepository(withName: repoName) { result in
            switch result {
            case .success(let existingRepo):
                if let repo = existingRepo {
                    // 이미 존재하면 기존 레포 반환
                    print("리포지토리가 이미 존재합니다. 기존 레포 사용: \(String(describing: repo.name))")
                    completion(.success(repo))
                } else {
                    // 존재하지 않으면 새로 생성 요청 진행
                    let endpoint = "/user/repos"
                    let parameters: [String: Any] = [
                        "name": repoName,
                        "description": description,
                        "private": isPrivate,
                        "auto_init": true
                    ]
                    
                    GithubRestManager.shared.request(endpoint: endpoint,
                                                       method: .POST,
                                                       parameters: parameters,
                                                       completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
