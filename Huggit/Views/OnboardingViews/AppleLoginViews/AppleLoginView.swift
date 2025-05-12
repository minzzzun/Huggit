import SwiftUI


struct AppleLoginView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        
        
        ZStack {
            Rectangle()
                .foregroundLinearGradient(
                    colors: [
                        Color.primaryDarkBlue,
                        Color.primaryDarkBlue,
                        Color.gradientBackground
                    ],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading,
                    stops: [0.0, 0.3, 1.0]
                    
                    
                )
                .ignoresSafeArea()
            
            
            VStack(spacing: 0) {
                Spacer()
                
                // 텍스트 영역
                VStack(alignment: .leading, spacing: 4) {
                    Text("개발자들의")
                        .textStyle(.h126SB)
                    
                    HStack(spacing: 0) {
                        Text("모든 성실")
                            .textStyle(.h126SB)
                            .foregroundColor(Color.primaryBlue)
                        Text("을 담다,")
                            .textStyle(.h126SB)
                    }

                    // TODO: 커스텀 폰트 "Wanted Sans Std" 추가해야함
                    Text("HUGGIT")
                        .textStyle(.loginFont)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // 이미지
                Image("loginImage")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width:254, height: 283)
                
                
                Spacer()
                
                
                // 애플 로그인 버튼
                AppleLoginButton()
                    .padding(.bottom, 50)
            }
        }
        .foregroundColor(Color.primaryWhite)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
    }
}

