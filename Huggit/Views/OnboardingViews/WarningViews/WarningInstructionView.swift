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
        HStack() {
            ZStack {
                Circle()
                    .fill(Color.gray300)
                    .frame(width: 27, height: 27)
                
                Text("\(num)")
                    .textStyle(.d115M)
                    .foregroundColor(.primaryWhite)
                
            }
            .padding(.leading, 20)
            
            formattedInstructionText
                .textStyle(.d115M)
                .lineLimit(2)
                .allowsTightening(true)
                .padding(.leading, 18)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 67)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray600)
        )
    }
    
    private var formattedInstructionText: Text {
        let parts = instruction.components(separatedBy: highlight)
        if parts.count == 2 {
            // 앞부분 + 강조 + 뒷부분
            return Text(parts[0])
                
                .foregroundColor(Color.gray300)
            + Text(highlight)
                
                .foregroundColor(.primaryWhite)
                .bold()
            + Text(parts[1])
                
                .foregroundColor(Color.gray300)
        } else {
            // highlight 문자열이 instruction 안에 없거나 여러 번 등장하는 경우엔 그냥 전체 문자열 출력
            return Text(instruction)
                .foregroundColor(Color.gray300)
        }
    }
}
