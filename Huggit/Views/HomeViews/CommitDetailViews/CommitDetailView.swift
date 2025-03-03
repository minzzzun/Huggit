//
//  CommitDetailView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct CommitDetailView: View {
    var arrowPosition: CGFloat = 0.5
    var arrowHeight: CGFloat = 11
    var tooltipWidth: CGFloat = .infinity
    var tooltipHeight: CGFloat = 255
    
    var body: some View {
        Tooltip(width: tooltipWidth, height: tooltipHeight, cornerRadius: 5, arrowHeight: arrowHeight, arrowPosition: arrowPosition, arrowTipRadius: 2, color: Color(hex: "1F2125"), arrowDirection: .up) {
            Text("CommitDetailView")
        }
    }
}
