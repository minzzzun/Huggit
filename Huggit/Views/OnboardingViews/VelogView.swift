import SwiftUI

struct VelogView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = VelogViewModel()
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.blackBackground)
                .ignoresSafeArea()
            
            VStack (spacing: 0){
                //헤더뷰
                OnboardingHeaderView(loginStep: 2)
                Spacer()
                    .frame(height: 50)
                
                //bodyView
                
                VStack(alignment: .leading,spacing: 15) {
                    Image("velogLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                    
                    
                    Text("Velog 닉네임을")
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundColor(.white)
                    Text("입력해주세요!")
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundColor(.white)
                    Text("* 선택")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.blueButton)
                    
                    TextField("", text: $viewModel.velogName, prompt: Text("닉네임을 입력하세요.")
                        .foregroundColor(Color.gray))
                    .padding() // 내부 패딩 추가
                    .background(Color.blackBackground) // 배경색 추가
                    .cornerRadius(5) // 모서리 둥글게
                    .foregroundColor(.white) // 입력 텍스트 색상
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray),
                        alignment: .bottom
                        
                    )
                    
                }
                
                Spacer()
                
                
                Text("입력하신 Velog 계정에 올리는 글을 잔디로 심어요!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.grayMessage)
                    .padding(.bottom, 19)
                
                
                Button(action:{
                    viewModel.saveVelog()
                    router.toNamed("/tistoryView")
                }){
                    Text(viewModel.velogName.isEmpty ? "건너뛰기" : "다음")
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color.blueButton)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 20)
        }
        .navigationBarHidden(true)
    }
}
