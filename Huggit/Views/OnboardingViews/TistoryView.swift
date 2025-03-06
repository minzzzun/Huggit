import SwiftUI


struct TistoryView: View {
    
    @StateObject private var viewModel = TistoryViewModel()
    @EnvironmentObject var router : NavigationRouter
    
    var body: some View {
        
        VStack{
            Spacer()
            Text("티스토리 닉네임을 입력하세요")
            TextField("닉네임을 입력하세요 ",text: $viewModel.tistoryName)
                .padding(.horizontal)
                .background(Color.gray)
                .cornerRadius(5)
                .padding()
            Spacer()
            Button(action:{
                viewModel.saveTistoryName()
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



