//
//  Tooltip.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

enum ArrowDirection {
    case up, down
}

struct Tooltip<Content: View>: View {
    // default는 header의 툴팁 상태
    var width: CGFloat = 121         // 직사각형 width
    var height: CGFloat = 25         // 직사각형 height
    var cornerRadius: CGFloat = 3
    var arrowHeight: CGFloat = 5.15     // 정삼각형의 높이
    var arrowPosition: CGFloat = 0.5 // 0~1: 해당 edge에서 좌측으로부터의 상대 위치 (0.5면 중앙)
    var arrowTipRadius: CGFloat = 1
    var color: Color = Color.gray500  // 전체 색상
    var arrowDirection: ArrowDirection = .down  // 화살표 방향: .down (아래쪽), .up (위쪽)
    
    let content: () -> Content
    
    var body: some View {
        
        ZStack() {
            TooltipShape(arrowDirection: arrowDirection,
                         arrowPosition: arrowPosition,
                         arrowHeight: arrowHeight,
                         arrowTipRadius: arrowTipRadius,
                         cornerRadius: cornerRadius)
                .fill(color)
                .frame(width: width, height: height)
            
            content()
                .frame(width: width, height: height)
                .offset(y: arrowDirection == .up ? arrowHeight / 2 : -arrowHeight / 2)
        }
    }
}

struct TooltipShape: Shape {
    var arrowDirection: ArrowDirection   // .up 또는 .down
    var arrowPosition: CGFloat           // 0.0 ~ 1.0, 상대 위치
    var arrowHeight: CGFloat             // 정삼각형의 높이
    var arrowTipRadius: CGFloat          // 화살표 끝의 radius
    var cornerRadius: CGFloat            // bubble의 모서리 반경

    func path(in rect: CGRect) -> Path {
        // 주어진 arrowHeight로부터 정삼각형의 변 길이 계산: side = (2 / √3) * arrowHeight
        let computedArrowSide = (2 / CGFloat(sqrt(3))) * arrowHeight
        let halfArrow = computedArrowSide / 2
        
        var path = Path()
        
        if arrowDirection == .down {
            let bubbleRect = CGRect(x: rect.minX,
                                    y: rect.minY,
                                    width: rect.width,
                                    height: rect.height)
            let tipX = rect.width * arrowPosition
            let arrowBaseLeft = tipX - halfArrow
            let arrowBaseRight = tipX + halfArrow
            
            // bubble (직사각형)
            path.move(to: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.minY))
            // 상단 직선
            path.addLine(to: CGPoint(x: bubbleRect.maxX - cornerRadius, y: bubbleRect.minY))
            // 우측 상단 모서리
            path.addArc(center: CGPoint(x: bubbleRect.maxX - cornerRadius, y: bubbleRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: -90),
                        endAngle: Angle(degrees: 0),
                        clockwise: false)
            // 우측 직선
            path.addLine(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY - cornerRadius))
            // 우측 하단 모서리
            path.addArc(center: CGPoint(x: bubbleRect.maxX - cornerRadius, y: bubbleRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: false)
            // 하단 직선: 오른쪽 모서리부터 arrow의 오른쪽 base까지
            path.addLine(to: CGPoint(x: arrowBaseRight, y: bubbleRect.maxY))
            
            // arrow 그리기: 오른쪽 base에서 tip까지
            if arrowTipRadius > 0 {
                path.addArc(tangent1End: CGPoint(x: tipX, y: bubbleRect.maxY + arrowHeight),
                            tangent2End: CGPoint(x: arrowBaseLeft, y: bubbleRect.maxY),
                            radius: arrowTipRadius)
            } else {
                path.addLine(to: CGPoint(x: tipX, y: bubbleRect.maxY + arrowHeight))
            }
            // arrow의 왼쪽 base로
            path.addLine(to: CGPoint(x: arrowBaseLeft, y: bubbleRect.maxY))
            // 하단 직선 계속: 왼쪽 모서리까지
            path.addLine(to: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.maxY))
            // 좌측 하단 모서리
            path.addArc(center: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
            // 좌측 직선
            path.addLine(to: CGPoint(x: bubbleRect.minX, y: bubbleRect.minY + cornerRadius))
            // 좌측 상단 모서리
            path.addArc(center: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 180),
                        endAngle: Angle(degrees: 270),
                        clockwise: false)
            path.closeSubpath()
        } else {
            // 위쪽 arrow: bubble 영역은 전체 rect에서 위쪽 arrowHeight만큼 아래로 이동한 영역
            let bubbleRect = CGRect(x: rect.minX,
                                    y: rect.minY + arrowHeight,
                                    width: rect.width,
                                    height: rect.height - arrowHeight)
            let tipX = rect.width * arrowPosition
            let arrowBaseLeft = tipX - halfArrow
            let arrowBaseRight = tipX + halfArrow
            
            // bubble 그리기 시작 (좌측 상단)
            path.move(to: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.minY))
            // 상단 직선: 왼쪽부터 arrow의 왼쪽 base까지
            path.addLine(to: CGPoint(x: arrowBaseLeft, y: bubbleRect.minY))
            // arrow 그리기: 왼쪽 base에서 tip까지
            if arrowTipRadius > 0 {
                path.addArc(tangent1End: CGPoint(x: tipX, y: bubbleRect.minY - arrowHeight),
                            tangent2End: CGPoint(x: arrowBaseRight, y: bubbleRect.minY),
                            radius: arrowTipRadius)
            } else {
                path.addLine(to: CGPoint(x: tipX, y: bubbleRect.minY - arrowHeight))
            }
            // arrow의 오른쪽 base로
            path.addLine(to: CGPoint(x: arrowBaseRight, y: bubbleRect.minY))
            // 상단 직선 계속: 오른쪽 모서리까지
            path.addLine(to: CGPoint(x: bubbleRect.maxX - cornerRadius, y: bubbleRect.minY))
            // 우측 상단 모서리
            path.addArc(center: CGPoint(x: bubbleRect.maxX - cornerRadius, y: bubbleRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: -90),
                        endAngle: Angle(degrees: 0),
                        clockwise: false)
            // 우측 직선
            path.addLine(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY - cornerRadius))
            // 우측 하단 모서리
            path.addArc(center: CGPoint(x: bubbleRect.maxX - cornerRadius, y: bubbleRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: false)
            // 하단 직선
            path.addLine(to: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.maxY))
            // 좌측 하단 모서리
            path.addArc(center: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
            // 좌측 직선
            path.addLine(to: CGPoint(x: bubbleRect.minX, y: bubbleRect.minY + cornerRadius))
            // 좌측 상단 모서리
            path.addArc(center: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 180),
                        endAngle: Angle(degrees: 270),
                        clockwise: false)
            path.closeSubpath()
        }
        
        return path
    }
}
