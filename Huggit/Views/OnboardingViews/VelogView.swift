import SwiftUI

struct VelogView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = VelogViewModel()
    var body: some View {
        VStack{
            Spacer()
            Text("벨로그 닉네임을 입력하세요")
            TextField("닉네임을 입력하세요 ",text: $viewModel.velogName)
                .padding(.horizontal)
                .background(Color.gray)
                .cornerRadius(5)
                .padding()
            Spacer()
            Button(action:{
                viewModel.saveVelog()
                router.toNamed("/")
            }){
                Text("다음")
                    .frame(width: 200,height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .navigationBarHidden(true)
    }
}
