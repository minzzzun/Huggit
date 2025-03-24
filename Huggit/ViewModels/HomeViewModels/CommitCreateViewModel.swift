//
//  CommitCreateViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/7/25.
//

import SwiftUI
import Combine

final class CommitCreateViewModel: ObservableObject {
    @Published var selectedCommit: Post? = nil {
        didSet {
            if let commit = selectedCommit {
                var typeString: String = ""
                switch commit.type {
                case .tistory:
                    typeString = "Tistory"
                case .velog:
                    typeString = "Velog"
                }
                commitTitle = "[\(typeString)] \(commit.title)"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                let dateString = dateFormatter.string(from: commit.date)
                
                commitDetails = "\(dateString)\n\(commit.link)\n\(commit.summary)"
            } else {
                commitTitle = ""
                commitDetails = ""
            }
        }
    }
    
    @Published var commitTitle: String = ""
    @Published var commitDetails: String = ""
    
    func cancelCommit() {
        selectedCommit = nil
    }
    
    func pushCommit() {
        guard let _ = selectedCommit else { return }
        
        let commitMessage = commitTitle
        let originalContent = commitDetails
        
        // 파일 내용 Base64 인코딩
        guard let data = originalContent.data(using: .utf8) else {
            print("Encoding Error")
            return
        }
        let base64Content = data.base64EncodedString()
        
        let repoOwner = "Kim-Min-Hyeok"
        let repoName = "NewRepo1"
        let filePath = "\(commitTitle.replacingOccurrences(of: " ", with: "_")).txt"
        
        // 먼저, 파일이 이미 존재하는지 확인하여 sha 값을 가져옵니다.
        GithubFileManager.shared.fetchFileSha(repoOwner: repoOwner, repoName: repoName, filePath: filePath) { result in
            switch result {
            case .success(let sha):
                // 파일이 존재하므로 업데이트 진행 (sha 포함)
                let commitPushRequest = CommitPushRequestModel(
                    message: commitMessage,
                    committer: Committer(name: "Kim-Min-Hyeok", email: "kkmin11203@gmail.com"),
                    content: base64Content,
                    sha: sha
                )
                
                GithubCommitPushManager.shared.pushCommit(repoOwner: repoOwner,
                                                           repoName: repoName,
                                                           filePath: filePath,
                                                           commitPushRequest: commitPushRequest) { pushResult in
                    DispatchQueue.main.async {
                        switch pushResult {
                        case .success(let response):
                            self.selectedCommit = nil
                        case .failure(let error):
                            print("Failed to push commit: \(error)")
                        }
                    }
                }
                
            case .failure(let error):
                // 에러 내부의 underlying error를 추출
                var code: Int? = nil
                if case let GithubAPIError.networkError(innerError) = error {
                    code = (innerError as NSError).code
                }
                
                if code == 404 {
                    // 파일이 존재하지 않으므로, sha 없이 새 파일 생성 요청 진행
                    let commitPushRequest = CommitPushRequestModel(
                        message: commitMessage,
                        committer: Committer(name: "Kim-Min-Hyeok", email: "kkmin11203@gmail.com"),
                        content: base64Content,
                        sha: nil
                    )
                    
                    GithubCommitPushManager.shared.pushCommit(repoOwner: repoOwner,
                                                               repoName: repoName,
                                                               filePath: filePath,
                                                               commitPushRequest: commitPushRequest) { pushResult in
                        DispatchQueue.main.async {
                            switch pushResult {
                            case .success(let response):
                                self.selectedCommit = nil
                            case .failure(let error):
                                print("Failed to push commit: \(error)")
                            }
                        }
                    }
                } else {
                    print("Failed to fetch file sha: \(error)")
                }
            }
        }

    }

}
