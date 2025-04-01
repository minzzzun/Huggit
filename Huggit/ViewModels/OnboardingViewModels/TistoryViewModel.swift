import SwiftUI

class TistoryViewModel: ObservableObject {
    @Published var tistoryName: String = UserInfo.tistoryName
    
    func saveTistoryName(){
        let trimmed = tistoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        UserInfo.tistoryName = trimmed.isEmpty ? "미등록" : trimmed
    }
}
