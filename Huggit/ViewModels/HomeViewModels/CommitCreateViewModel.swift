//
//  CommitCreateViewModel.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/7/25.
//

import SwiftUI
import Combine

final class CommitCreateViewModel: ObservableObject {
    @Published var selectedCommit: Post? = nil {
        didSet {
            if let commit = selectedCommit {
                var typeString: String = ""
                switch commit.type {
                case .tistory:
                    typeString = "Tistory"
                case .velog:
                    typeString = "Velog"
                }
                commitTitle = "[\(typeString)] \(commit.title)"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                let dateString = dateFormatter.string(from: commit.date)
                
                commitDetails = "\(dateString)\n\(commit.link)\n\(commit.summary)"
            } else {
                commitTitle = ""
                commitDetails = ""
            }
        }
    }
    
    @Published var commitTitle: String = ""
    @Published var commitDetails: String = ""
    
    func cancelCommit() {
        selectedCommit = nil
    }
    
    func pushCommit() {
        selectedCommit = nil
    }
}
