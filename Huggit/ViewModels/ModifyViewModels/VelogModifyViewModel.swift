//
//  VelogModifyViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/9/25.
//

import SwiftUI

class VelogModifyViewModel: ObservableObject {
    @Published var velogName: String = UserInfo.velogName {
        didSet {
            if oldValue != velogName {
                showError = false
            }
        }
    }
    @Published var showError: Bool = false
    
    func saveVelogName(){
        let trimmed = velogName.trimmingCharacters(in: .whitespacesAndNewlines)
        UserInfo.velogName = trimmed.isEmpty ? "미등록" : trimmed
    }
    
    func validateVelog(completion: @escaping (Bool) -> Void) {
        let trimmed = velogName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != "미등록" else {
            completion(true)
            return
        }
        
        VelogUserManager.shared.isVelogUser(username: trimmed) { [weak self] isValid in
            DispatchQueue.main.async {
                self?.showError = !isValid
                completion(isValid)
            }
        }
    }
}

