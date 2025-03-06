//
//  CalendarHeaderButtonView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 2/27/25.
//

import SwiftUI

struct CalendarHeaderButtonView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var calendarViewModel: CalendarViewModel {
        homeViewModel.calendarViewModel
    }
    @State private var textWidth: CGFloat = 0
    
    // 파라미터들
    let title: String
    let grassType: CurrentGrass
    let startColor: Color
    let endColor: Color
    
    var isActive: Bool {
        calendarViewModel.currentGrass == grassType
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                calendarViewModel.currentGrass = grassType
            }) {
                Group {
                    if isActive {
                        Text(title)
                            .foregroundLinearGradient(colors: [startColor, endColor],
                                                      startPoint: .leading,
                                                      endPoint: .trailing)
                    } else {
                        Text(title)
                            .foregroundColor(.gray)
                    }
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                textWidth = geometry.size.width
                            }
                    }
                )
                .font(.system(size: 14))
                .fixedSize()
            }
            .padding(.bottom, 8)
            
            if isActive {
                Divider()
                    .frame(width: textWidth, height: 1)
                    .background(Color.white)
                    .foregroundLinearGradient(colors: [startColor, endColor],
                                              startPoint: .leading,
                                              endPoint: .trailing)
            } else {
                Divider()
                    .frame(width: textWidth, height: 1)
                    .background(Color.gray)
            }
        }
    }
}

