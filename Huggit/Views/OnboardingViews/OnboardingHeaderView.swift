import SwiftUI

struct OnboardingHeaderView: View {
    @EnvironmentObject var router: NavigationRouter
    
    @State private var loginLength: Int = 0
    @State private var initialPathCount: Int = 0
    
    var body: some View {
        HStack {
            if initialPathCount > 1 {
                Button(action: {
                    if let lastRoute = router.path.last {
                        var loginRoute: LoginRoute? = nil
                        if lastRoute.name.contains("appleLogin") {
                            loginRoute = .apple
                        } else if lastRoute.name.contains("githubLogin") {
                            loginRoute = .github
                        } else if lastRoute.name.contains("velogView") {
                            loginRoute = .velog
                        } else if lastRoute.name.contains("tistoryView") {
                            loginRoute = .tistory
                        }
                        
                        if let route = loginRoute {
                            router.loginRouteStack.append(route)
                        }
                    }
                    router.back()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                }
            } else {
                EmptyView()
            }
            
            Spacer()
            
            // 페이지 인디케이터
            HStack(spacing: 4) {
                ForEach(Array(0..<loginLength), id: \.self) { index in
                    Circle()
                        .fill(index < initialPathCount ? Color.blueButton : Color.gray.opacity(0.5))
                        .frame(width: 6, height: 6)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 25)
        .onAppear {
            initialPathCount = router.path.count
            loginLength = router.loginLength
            
            if loginLength > 3 {
                loginLength -= 1
                initialPathCount -= 1
            }
        }
    }
}
