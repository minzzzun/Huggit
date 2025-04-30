//
//  TistoryModifyViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/9/25.
//

import SwiftUI

class TistoryModifyViewModel: ObservableObject {
    @Published var tistoryName: String = UserInfo.tistoryName {
        didSet {
            if oldValue != tistoryName {
                showError = false
            }
        }
    }
    @Published var showError: Bool = false
    
    func saveTistoryName(){
        let trimmed = tistoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        UserInfo.tistoryName = trimmed.isEmpty ? "미등록" : trimmed
    }
    
    func validateTistory(completion: @escaping (Bool) -> Void) {
        let trimmed = tistoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != "미등록" else {
            completion(true)
            return
        }
        
        TistoryUserManager.shared.isTistoryUser(username: trimmed) { [weak self] isValid in
            DispatchQueue.main.async {
                self?.showError = !isValid
                completion(isValid)
            }
        }
    }
}

