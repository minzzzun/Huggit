//
//  GithubUserManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

final class GithubUserManager {
    static let shared = GithubUserManager()
    private init() {}
    
    func fetchUser(completion: @escaping (Result<GithubUser, GithubAPIError>) -> Void) {
        let endpoint = "/user"
        GithubRestManager.shared.request(endpoint: endpoint,
                                         method: .GET,
                                         parameters: nil,
                                         completion: completion)
    }
    
    func fetchUserEmails(completion: @escaping (Result<[GithubUserEmail], GithubAPIError>) -> Void) {
        let endpoint = "/user/emails"
        GithubRestManager.shared.request(endpoint: endpoint,
                                         method: .GET,
                                         parameters: nil,
                                         completion: completion)
    }
    
    func validateGithubInfo(completion: @escaping (Bool) -> Void) {
        guard !UserInfo.gitLogin.isEmpty else {
            print("Github login 없음")
            completion(false)
            return
        }
        guard !UserInfo.gitName.isEmpty else {
            print("Github name 없음")
            completion(false)
            return
        }
        guard !UserInfo.gitEmail.isEmpty else {
            print("Github Email 없음")
            completion(false)
            return
        }
        guard !UserInfo.repoName.isEmpty else {
            print("Github name 없음")
            completion(false)
            return
        }
        
        let group = DispatchGroup()
        var isValid = true
        
        // github 유저 정보 확인
        group.enter()
        fetchUser { result in
            switch result {
            case .success(let fetchedUser):
                if fetchedUser.login != UserInfo.gitLogin {
                    print("gitLogin 불일치")
                    isValid = false
                }
                let fetchedName = fetchedUser.name ?? fetchedUser.login
                if fetchedName != UserInfo.gitName {
                    print("gitName 불일치")
                    isValid = false
                }
            case .failure(let error):
                print("Github 유저 불러오기 실패: \(error)")
                isValid = false
            }
            group.leave()
        }
        
        // github 이메일 정보 확인
        group.enter()
        fetchUserEmails { result in
            switch result {
            case .success(let emails):
                if let primary = emails.first(where: { $0.primary}) {
                    if primary.email != UserInfo.gitEmail {
                        print("gitEmail 불일치")
                        isValid = false
                    }
                }
                else if let first = emails.first {
                    if first.email != UserInfo.gitEmail {
                        print("gitEmail 불일치")
                        isValid = false
                    }
                }
                else {
                    print("유효한 이메일 없음")
                    isValid = false
                }
            case . failure(let error):
                print("Github 이메일 불러오기 실패: \(error)")
                isValid = false
            }
            group.leave()
        }
        
        group.enter()
        GithubRepoManager.shared.findRepository(withName: UserInfo.repoName) { result in
            switch result {
            case .success(let repo):
                if repo == nil {
                    print("Repository '\(UserInfo.repoName)' 존재하지 않음")
                    isValid = false
                }
            case .failure(let error):
                print("findRepository 실패 \(error)")
                isValid = false
            }
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            completion(isValid)
        }
    }
}
