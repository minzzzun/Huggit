//
//  LineNumberTextEditor.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/24/25.
//

import SwiftUI

struct LineNumberTextEditor: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> LineNumberTextView {
        let view = LineNumberTextView()
        view.textView.text = text
        view.lineNumberView.text = text
        return view
    }
    
    func updateUIView(_ uiView: LineNumberTextView, context: Context) {
        if uiView.textView.text != text {
            uiView.textView.text = text
            uiView.lineNumberView.text = text
        }
        uiView.lineNumberView.setNeedsDisplay()
    }
}
