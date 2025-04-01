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
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
            }
            
            Spacer()
            
            if router.path.last?.name != "/warning" {
                // 페이지 인디케이터
                HStack(spacing: 4) {
                    ForEach(Array(0..<router.loginLength), id: \.self) { index in
                        Circle()
                            .fill(index < loginStep ? Color.blueButton : Color.gray.opacity(0.5))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.top, 25)
    }
}
