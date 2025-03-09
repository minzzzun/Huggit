import Foundation

final class GithubRepoManager {
    static let shared = GithubRepoManager()
    
    private init() {}
    
    func createRepository(accessToken: String, name: String, description: String, isPrivate: Bool, completion: @escaping (Result<GithubRepository, GithubAPIError>) -> Void) {
        let endpoint = "/user/repos"
        let parameters: [String: Any] = [
            "name": name,
            "description": description,
            "private": isPrivate,
            "auto_init": true
        ]
        
        var headers = [String: String]()
        headers["Authorization"] = "token \(accessToken)"
        headers["Accept"] = "application/vnd.github.v3+json"
        
        GithubRestManager.shared.request(endpoint: endpoint, method: .POST, parameters: parameters) { (result: Result<Data, GithubAPIError>) in
            switch result {
            case .success(let data):
                do {
                    let repository = try JSONDecoder().decode(GithubRepository.self, from: data)
                    completion(.success(repository))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    
}
