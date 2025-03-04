import SwiftUI


struct GithubLoginHeaderView: View {
    @EnvironmentObject var router : NavigationRouter
    
    var body: some View {
        HStack {
            Button(action: {
                router.back()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
            }
            Spacer()
            
            // 페이지 인디케이터
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.blueButton)
                    .frame(width: 6, height: 6)
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 6, height: 6)
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 6, height: 6)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 25)
    }
}


