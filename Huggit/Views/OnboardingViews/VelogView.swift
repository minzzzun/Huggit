import SwiftUI

struct VelogView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = VelogViewModel()
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.primaryDarkBlue)
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }
            
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
                        .foregroundColor(.primaryWhite)
                    Text("입력해주세요!")
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundColor(.primaryWhite)
                    Text("* 선택")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.primaryBlue)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("", text: $viewModel.velogName, prompt: Text("닉네임을 입력하세요.")
                            .foregroundColor(.gray300)
                        )
                        .padding(.vertical)
                        .background(Color.primaryDarkBlue)
                        .cornerRadius(5)
                        .foregroundColor(viewModel.showError ? .errorRed : .primaryWhite)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray300),
                            alignment: .bottom
                        )
                        
                        if viewModel.showError {
                            HStack (spacing: 6){
                                Image("error")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 13.5)
                                Text("존재하지 않는 닉네임이에요")
                                    .font(.system(size: 12))
                                    .foregroundColor(.errorRed)
                            }
                        }
                    }
                }
                
                Spacer()
                
                
                Text("입력하신 Velog 계정에 올리는 글을 잔디로 심어요!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray300)
                    .padding(.bottom, 19)
                
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                    viewModel.validateVelog { isValid in
                        if isValid {
                            viewModel.saveVelogName()
                            router.toNamed("/tistoryView")
                        }
                    }
                }) {
                    Text(viewModel.velogName.isEmpty ? "건너뛰기" : "다음")
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color.primaryBlue)
                        .foregroundColor(.primaryWhite)
                        .cornerRadius(10)
                }
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 20)
        }
        .navigationBarHidden(true)
    }
}
