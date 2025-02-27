import SwiftUI


struct GithubLoginView : View {
    var body: some View {
        
        VStack {
            Button(action: {
                print("깃허브 로그인")
            }){
                Text("깃허브 로그인")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
        }
        .navigationBarHidden(true)
        
       
    }
}
