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
        endPoint: UnitPoint,
        stops: [Double]? = nil
    ) -> some View {
        self.overlay(
            LinearGradient(
                stops: zip(
                    stops ?? Array(stride(from: 0, through: 1, by: 1.0 / Double(colors.count - 1))),
                    colors
                ).map { Gradient.Stop(color: $1, location: $0) },
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self
            )
        )
    }
}
