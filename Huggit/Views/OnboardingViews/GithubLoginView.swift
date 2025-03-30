import SwiftUI


struct GithubLoginView : View {
    @StateObject private var viewModel = GithubLoginViewModel()
    @EnvironmentObject var router : NavigationRouter
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.blackBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // HeaderView
                OnboardingHeaderView(activeIndex: 0)
                Spacer()
                    .frame(height: 50)

                // BodyView
                HStack {
                    // GitHub 로고와 텍스트
                    VStack(alignment: .leading ,spacing: 16) {
                        Image("githubLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading,spacing: 8) {
                            Text("깃허브 연동이")
                                .font(.system(size: 24, weight: .bold))
                            Text("필요해요!")
                                .font(.system(size: 24, weight: .bold))
                        } // v
                        
                        Text("깃허브 잔디 정보를 불러오는 데 사용돼요!")
                            .font(.system(size: 14))
                            .foregroundColor(.blueButton)
                    }// v
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // 깃허브 로그인 버튼
                Button(action: {
                    print("깃허브 로그인")
                    viewModel.requestCode()
                    router.offAll(router.popNextLoginRoute())
                }) {
                    Text("깃허브 로그인")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color.blueButton)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 58)
                
            }
            
        }
        .foregroundColor(.white)
        .navigationBarHidden(true)
        
        
        .navigationBarHidden(true)
        .onOpenURL { url in
            print("🔗 URL received: \(url)")
            
            guard url.scheme == "githubprviewer", url.host == "login" else {
                print("❌ Invalid URL Scheme or Host: \(url)")
                return
            }
            
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let queryItems = components.queryItems,
               let code = queryItems.first(where: { $0.name == "code" })?.value {
                print("✅ GitHub Authorization Code: \(code)")
                viewModel.requestAccessToken(code: code)
            } else {
                print("❌ Failed to extract code from URL")
            }
        }
        
    }
}
