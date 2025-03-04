import SwiftUI

class TistoryViewModel: ObservableObject {
    @Published var tistoryName: String = ""
    
    func saveTistoryName(){
        UserDefaults.standard.set(tistoryName, forKey: "tistoryName")
    }
}
