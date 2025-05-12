//
//  TextStyle.swift
//  Huggit
//
//  Created by Minhyeok Kim on 5/11/25.
//

import SwiftUI

struct TextStyle {
    let font: Font
    let size: CGFloat
    let lineHeightMultiplier: CGFloat
    let letterSpacing: CGFloat

    var additionalLineSpacing: CGFloat {
        size * (lineHeightMultiplier - 1)
    }
}

extension TextStyle {
    // MARK: - Heading
    static let h126SB = TextStyle(font: .h126SB, size: 26,
                                   lineHeightMultiplier: 1.5, letterSpacing: 0)
    static let h227SB = TextStyle(font: .h227SB, size: 27,
                                   lineHeightMultiplier: 1.3, letterSpacing: 0)
    static let h323SB = TextStyle(font: .h323SB, size: 23,
                                   lineHeightMultiplier: 1.5, letterSpacing: 0)
    static let h421M  = TextStyle(font: .h421M,  size: 21,
                                   lineHeightMultiplier: 1.3, letterSpacing: 0)
    static let h518SB = TextStyle(font: .h518SB, size: 18,
                                   lineHeightMultiplier: 1.3, letterSpacing: 0)
    static let h615M  = TextStyle(font: .h615M,  size: 15,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)

    // MARK: - Subtitle
    static let s114M = TextStyle(font: .s114M, size: 14,
                                  lineHeightMultiplier: 1.5, letterSpacing: 0)
    static let s213M = TextStyle(font: .s213M, size: 13,
                                  lineHeightMultiplier: 1.3, letterSpacing: 0)

    // MARK: - Display
    static let d115M = TextStyle(font: .d115M, size: 15,
                                  lineHeightMultiplier: 1.4, letterSpacing: 0)
    static let d222L = TextStyle(font: .d222L, size: 22,
                                  lineHeightMultiplier: 35/22, letterSpacing: 0)
    static let d39M  = TextStyle(font: .d39M,  size: 9,
                                  lineHeightMultiplier: 1.0, letterSpacing: 0)
    static let d415R = TextStyle(font: .d415R, size: 15,
                                  lineHeightMultiplier: 1.3, letterSpacing: -0.02 * 15)
    static let d515B = TextStyle(font: .d515B, size: 15,
                                  lineHeightMultiplier: 1.35, letterSpacing: 0)
    static let d611M = TextStyle(font: .d611M, size: 11,
                                  lineHeightMultiplier: 1.45, letterSpacing: 0)
    static let d714L = TextStyle(font: .d714L, size: 14,
                                  lineHeightMultiplier: 1.0, letterSpacing: 0)

    // MARK: - Button
    static let b117SB = TextStyle(font: .b117SB, size: 17,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)
    static let b213R  = TextStyle(font: .b213R,  size: 13,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)

    // MARK: - Calendar
    static let c114R  = TextStyle(font: .c114R, size: 14,
                                   lineHeightMultiplier: 1.0, letterSpacing: -0.05 * 14)
    static let c29R   = TextStyle(font: .c29R,  size: 9,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)
    static let c312R  = TextStyle(font: .c312R, size: 12,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)
    static let c411R  = TextStyle(font: .c411R, size: 11,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)
    static let c514SB = TextStyle(font: .c514SB, size: 14,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)
    static let c67M   = TextStyle(font: .c67M,   size: 7,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)
    static let c712SB = TextStyle(font: .c712SB, size: 12,
                                   lineHeightMultiplier: 1.0, letterSpacing: 0)
    
    // MARK: - Login
    static let loginFont = TextStyle(font: .loginFont, size: 45,
                                     lineHeightMultiplier: 1.5, letterSpacing: -0.5)

}
