import SwiftUI

struct TistoryView : View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = TistoryViewModel()
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.blackBackground)
                .ignoresSafeArea()
            
            VStack (spacing: 0){
                //헤더뷰
                OnboardingHeaderView(activeIndex: 2)
                Spacer()
                    .frame(height: 50)

                //bodyView
                
                VStack(alignment: .leading,spacing: 15) {
                    Image("tistoryLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                    
                    
                    Text("Tistory 닉네임을")
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundColor(.white)
                    Text("입력해주세요!")
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundColor(.white)
                    Text("* 선택")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.blueButton)

                    TextField("", text: $viewModel.tistoryName, prompt: Text("닉네임을 입력하세요.")
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
                .padding(.horizontal, 20)
                
                Spacer()
                
                
                Text("Tistory 계정이 있을 시에만 작성해주세요!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.grayMessage)
                    .padding(.bottom, 19)
                
                
                Button(action:{
                    viewModel.saveTistoryName()
                    router.toNamed("/")
                }){
                    Text(viewModel.tistoryName.isEmpty ? "건너뛰기" : "다음")
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color.blueButton)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 48)
                
            }
        }// z
        .navigationBarHidden(true)
    }
}

