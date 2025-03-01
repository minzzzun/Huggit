import SwiftUI

// TODO: TEST를 위해 만든 코드, 나중에 삭제!
class HomeViewViewModel: ObservableObject{
    var defaults = UserDefaults.standard
    
    func deleteAppleLogin(){
        defaults.removeObject(forKey: "appleId")
    }
}
