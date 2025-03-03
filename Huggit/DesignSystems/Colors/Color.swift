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

