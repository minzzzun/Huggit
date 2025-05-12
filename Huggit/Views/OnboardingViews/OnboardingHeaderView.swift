import SwiftUI

struct OnboardingHeaderView: View {
    @EnvironmentObject var router: NavigationRouter
    let loginStep: Int
    
    var body: some View {
        HStack {
            Button(action: {
                router.back()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primaryWhite)
            }
            
            Spacer()
            
            if let lastPath = router.path.last?.name,
               lastPath != "/warning",
               !lastPath.hasSuffix("Modify")
            {
                // 페이지 인디케이터
                HStack(spacing: 4) {
                    ForEach(0..<router.loginLength, id: \.self) { index in
                        Circle()
                            .fill(index < loginStep ? Color.primaryBlue : Color.gray500)
                            .frame(width: 6, height: 6)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.top, 25)
    }
}
