import SwiftUI

struct OnboardingHeaderView: View {
    @EnvironmentObject var router: NavigationRouter
    let loginStep: Int
    
    var body: some View {
        HStack {
            Button(action: {
                router.back()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 18)
                        .foregroundColor(.primaryWhite)
                    Spacer()
                }
            }
            .frame(width: 50, height: 38)
            
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
            
            Spacer()
                .frame(width: 50, height: 38)
        }
        .frame(maxWidth: .infinity, maxHeight: 38)
        .padding(.top, 25)
    }
}
