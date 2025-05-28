//
//  SafariView.swift
//  Huggit
//
//  Created by 김민준 on 5/28/25.
//

import SwiftUI
import SafariServices


struct SafariView: UIViewControllerRepresentable {
    let url : URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
}

