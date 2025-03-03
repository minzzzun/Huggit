//
//  Util.swift
//  Huggit
//
//  Created by 김민준 on 2/19/25.
//

import SwiftUI

extension View {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint) -> some View
    {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self
            )
        )
    }
}
