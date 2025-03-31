//
//  GithubCommitPushManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/17/25.
//

import Foundation

final class GithubCommitPushManager {
    static let shared = GithubCommitPushManager()
    private init() {}
    
    func pushCommit(repoOwner: String,
                    repoName: String,
                    filePath: String,
                    commitPushRequest: CommitPushRequestModel,
                    completion: @escaping (Result<CommitPushResponseModel, GithubAPIError>) -> Void) {
        let endpoint = "/repos/\(repoOwner)/\(repoName)/contents/\(filePath)"
        
        guard let parameters = commitPushRequest.dictionary else {
            completion(.failure(.networkError(NSError(domain: "Encoding Error", code: 0, userInfo: nil))))
            return
        }
        
        GithubRestManager.shared.request(endpoint: endpoint,
                                           method: .PUT,
                                           parameters: parameters,
                                           completion: completion)
    }
}
