import SwiftUI


class VelogViewModel: ObservableObject {
    @Published var velogName: String = ""
    
    func saveVelog(){
        UserDefaults.standard.set(velogName, forKey: "velogName")
    }
}
