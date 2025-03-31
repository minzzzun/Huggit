import SwiftUI

class TistoryViewModel: ObservableObject {
    @Published var tistoryName: String = ""
    
    func saveTistoryName(){
        let trimmed = tistoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        UserInfo.tistoryName = trimmed.isEmpty ? "미등록" : trimmed
    }
}
