//
//  Text.swift
//  Huggit
//
//  Created by Minhyeok Kim on 5/11/25.
//

import SwiftUI

extension Text {
    func textStyle(_ style: TextStyle) -> some View {
        self
            .font(style.font)
            .lineSpacing(style.additionalLineSpacing)
            .kerning(style.letterSpacing)
    }
}
