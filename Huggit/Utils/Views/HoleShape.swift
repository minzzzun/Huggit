//
//  HoleShape.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

// 전체 영역에서 특정 사각형(holeRect)을 제외
struct HoleShape: Shape {
    var holeRect: CGRect
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.addRect(holeRect)
        return path
    }
}
