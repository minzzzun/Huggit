//
//  WarningInstructionView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/1/25.
//

import SwiftUI

struct WarningInstructionView: View {
    let num: Int
    let instruction: String
    let highlight: String
    
    var body: some View {
        HStack(spacing: 25) {
            ZStack {
                Circle()
                    .fill(Color(hex: "484E5A"))
                    .frame(width: 27, height: 27)
                
                Text("\(num)")
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .semibold))
            }
            .padding(.leading, 20)
            
            formattedInstructionText
                .font(.system(size: 15))
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 67)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "1F2125"))
        )
    }
    
    private var formattedInstructionText: Text {
        let parts = instruction.components(separatedBy: highlight)
        if parts.count == 2 {
            // 앞부분 + 강조 + 뒷부분
            return Text(parts[0])
                .foregroundColor(Color(hex: "484E5A"))
            + Text(highlight)
                .foregroundColor(.white)
                .bold()
            + Text(parts[1])
                .foregroundColor(Color(hex: "484E5A"))
        } else {
            // highlight 문자열이 instruction 안에 없거나 여러 번 등장하는 경우엔 그냥 전체 문자열 출력
            return Text(instruction)
                .foregroundColor(Color(hex: "484E5A"))
        }
    }
}
