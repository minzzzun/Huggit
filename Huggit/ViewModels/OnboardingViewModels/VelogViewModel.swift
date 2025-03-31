import SwiftUI


class VelogViewModel: ObservableObject {
    @Published var velogName: String = ""
    
    func saveVelog(){
        let trimmed = velogName.trimmingCharacters(in: .whitespacesAndNewlines)
        UserInfo.velogName = trimmed.isEmpty ? "미등록" : trimmed
    }
}
