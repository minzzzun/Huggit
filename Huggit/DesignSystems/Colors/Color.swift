//
//  Color.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // MARK: code Blue
    static let codeBlue000 = Color(hex: "e6edff")
    static let codeBlue100 = Color(hex: "d9e4ff")
    static let codeBlue200 = Color(hex: "b0c6ff")
    static let codeBlue300 = Color(hex: "0048ff")
    static let codeBlue400 = Color(hex: "0041e6")
    static let codeBlue500 = Color(hex: "003acc")
    static let codeBlue600 = Color(hex: "0036bf")
    static let codeBlue700 = Color(hex: "002b99")
    static let codeBlue800 = Color(hex: "002073")
    static let codeBlue900 = Color(hex: "001959")
    
    // MARK: code Green
    static let codeGreen000 = Color(hex: "f0faf0")
    static let codeGreen100 = Color(hex: "e9f8e8")
    static let codeGreen200 = Color(hex: "d1f0cf")
    static let codeGreen300 = Color(hex: "6cd064")
    static let codeGreen400 = Color(hex: "61bb5a")
    static let codeGreen500 = Color(hex: "56a650")
    static let codeGreen600 = Color(hex: "519c4b")
    static let codeGreen700 = Color(hex: "417d3c")
    static let codeGreen800 = Color(hex: "315e2d")
    static let codeGreen900 = Color(hex: "264923")
    
    // MARK: System
    static let errorRed = Color(hex: "912121")
    static let noticGreen = Color(hex: "39D57A")
    static let stampGreen = Color(hex: "3E8D4B")
    static let semiBlue = Color(hex: "407DD5")
    static let stampGray = Color(hex: "5C5C5C")
    
    // MARK: Primary
    static let primaryWhite = Color(hex: "FFFFFF")
    static let primaryDarkBlue = Color(hex: "121317")
    static let primaryBlue = Color(hex: "3182F7")
    
    static let gradientBackground = Color(hex: "3E4046")
    
    // MARK: Gray
    static let gray000 = Color(hex: "F8F6FC")
    static let gray100 = Color(hex: "84898F")
    static let gray200 = Color(hex: "606060")
    static let gray300 = Color(hex: "484E5A")
    static let gray400 = Color(hex: "3C3C46")
    static let gray500 = Color(hex: "282A2F")
    static let gray600 = Color(hex: "1F2125")
    
    
    // TODO: 나중에 삭제할 것
    static let grayMessage = Color(hex: "484E5A")
    
    static let blackBackground = Color(hex: "121317")
    
    static let greenLess = Color(hex: "181B21")
    static let greenLow = Color(hex: "1F432B")
    static let greenMedium = Color(hex: "2E6B38")
    static let greenHigh = Color(hex: "52A44E")
    static let greenMore = Color(hex: "6CD064")
    
    static let blueLess = Color(hex: "1C2026")
    static let blueLow = Color(hex: "1F3364")
    static let blueMedium = Color(hex: "2F52A9")
    static let blueHigh = Color(hex: "0038FF")
    static let blueMore = Color(hex: "0048FF")
    static let blueButton = Color(hex: "3182F7")
    
    
        
}

