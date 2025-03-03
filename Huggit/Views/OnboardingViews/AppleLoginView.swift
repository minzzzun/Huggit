import SwiftUI


struct AppleLoginView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // 텍스트 영역
            VStack(alignment: .leading, spacing: 4) {
                Text("개발자들의")
                    .font(.system(size: 26, weight: .regular))
                    .fontWeight(.semibold)
                HStack(spacing: 0) {
                    Text("모든 성실")
                        .foregroundColor(.blue)
                    Text("을 담다,")
                }
                .font(.system(size: 26, weight: .regular))
                .fontWeight(.semibold)
                
                Text("HUGGIT")
                    .font(.system(size: 45, weight: .bold))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
        .foregroundColor(.white)
        .navigationBarHidden(true)
    }
}

