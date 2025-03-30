//
//  GithubFileManger.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/17/25.
//

import Foundation

final class GithubFileManager {
    static let shared = GithubFileManager()
    private init() {}
    
    func fetchFileSha(repoOwner: String,
                      repoName: String?,
                      filePath: String,
                      completion: @escaping (Result<String, GithubAPIError>) -> Void) {
        let endpoint = "/repos/\(repoOwner)/\(String(describing: repoName))/contents/\(filePath)"
        // FileContent 모델은 기존에 정의된 CommitPushResponseModel.FileContent와 동일한 구조로 사용합니다.
        GithubRestManager.shared.request(endpoint: endpoint, method: .GET, parameters: nil) { (result: Result<FileContent, GithubAPIError>) in
            switch result {
            case .success(let fileContent):
                completion(.success(fileContent.sha))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
