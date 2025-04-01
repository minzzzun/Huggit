

import Combine
import SwiftUI

enum LoginRoute: String, CaseIterable {
    case apple
    case github
    case velog
    case tistory
}

/// Combine & NavigationStack을 활용한 라우팅 상태 관리
final class NavigationRouter: ObservableObject {
    /// NavigationStack 에서 관리할 경로 배열
    @Published var path: [Route] = []
    
    /// 로그인 과정 길이
    @Published var loginLength: Int = 3
    
    /// 해당 경로로 이동 (push)
    func toNamed(_ route: String, arguments: AnyHashable? = nil) {
        let newRoute = Route(name: route, arguments: arguments)
        path.append(newRoute)
    }
    
    /// 뒤로가기 (pop)
    func back() {
        _ = path.popLast()
    }
    
    /// 현재 화면을 제거하고 해당 경로로 이동 (replace)
    func offNamed(_ route: String, arguments: AnyHashable? = nil) {
        if !path.isEmpty {
            _ = path.popLast()
        }
        toNamed(route, arguments: arguments)
    }
    
    /// 전체 스택을 비우고 해당 경로를 새 루트로 설정
    func offAll(_ route: String, arguments: AnyHashable? = nil) {
        path.removeAll()
        toNamed(route, arguments: arguments)
    }
    
    // 로그인 유효성 검사 (stack으로 할 것이라 반대 순서대로 push)
    func isNeededLogin(completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        
        let missingTistory = UserInfo.tistoryName.isEmpty
        let missingVelog = UserInfo.velogName.isEmpty
        let missingApple = UserInfo.appleId.isEmpty
        var missingGitHub = false
        
        if UserInfo.githubAccessToken.isEmpty || UserInfo.gitLogin.isEmpty {
            missingGitHub = true
        } else {
            group.enter()
            GithubUserManager.shared.validateGithubInfo { isValid in
                missingGitHub = !isValid
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            // 하나라도 missing이면 로그인 필요(true)
            let needLogin = missingTistory || missingVelog || missingGitHub || missingApple
            print("로그인 필요 여부: \(needLogin)")
            completion(needLogin)
        }
    }
}
