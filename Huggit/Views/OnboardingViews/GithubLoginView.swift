import SwiftUI


struct GithubLoginView : View {
    @StateObject private var viewModel = GithubLoginViewModel()
    @EnvironmentObject var router : NavigationRouter
    
    var body: some View {
        
        VStack {
            Button(action: {
                print("깃허브 로그인")
                viewModel.requestCode()
                router.toNamed("/")
            }){
                Text("깃허브 로그인")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            
            
        
            
            
        }
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
