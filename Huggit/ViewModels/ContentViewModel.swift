import SwiftUI

class ContentViewModel : ObservableObject {
    @Published var isAppleLogined : Bool = false

    var defaults = UserDefaults.standard
    
    // 애플로그인 했는지 확인 
    func checkAppleLogin(){
        let appleId = defaults.string(forKey: "appleId") ?? ""
        if appleId == ""  {
            isAppleLogined = false
        } else {
            isAppleLogined = true
        }
        
    }

    
    
}
