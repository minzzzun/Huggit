

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
    
    /// 로그인 스택: 현재 userDefault 상태에 따라 생성 (유효성 검사)
    @Published var loginRouteStack: [LoginRoute] = []
    
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
    func updateLoginStatus(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        print("velog: \(UserInfo.velogName)\ntistory: \(UserInfo.tistoryName)")
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
            var missingRoutes = [LoginRoute]()
            // 원하는 순서: 티스토리 → 벨로그 → 깃허브 → 애플
            if missingTistory { missingRoutes.append(.tistory) }
            if missingVelog { missingRoutes.append(.velog) }
            if missingGitHub { missingRoutes.append(.github) }
            if missingApple { missingRoutes.append(.apple) }
            
            self.loginRouteStack = missingRoutes
            print("업데이트된 로그인 스택: \(self.loginRouteStack.map { $0.rawValue })")
            completion()
        }
    }
    
    /// 스택이 비어있으면 "/"
    func popNextLoginRoute() -> String {
        if let next = loginRouteStack.popLast() {
            return routeForLogin(next)
        } else {
            return "/"
        }
    }
    
    private func routeForLogin(_ route: LoginRoute) -> String {
        switch route {
        case .apple:
            return "/appleLogin"
        case .github:
            return "/githubLogin"
        case .velog:
            return "/velogView"
        case .tistory:
            return "/tistoryView"
        }
    }
}
