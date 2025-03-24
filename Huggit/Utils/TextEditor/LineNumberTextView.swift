//
//  LineNumberView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/24/25.
//

import UIKit
import SwiftUI

class LineNumberView: UIView {
    var text: String = ""
    var contentOffset: CGPoint = .zero
    
    // 텍스트뷰의 글꼴(14픽셀)과 라인 번호 글꼴(12픽셀)을 상수로 지정합니다.
    let textFont: UIFont = UIFont.systemFont(ofSize: 14)
    let numberFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isOpaque = false
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 투명한 배경 채우기
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(rect)
        
        // 라인 번호는 12픽셀 글꼴 사용
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: numberFont,
            .foregroundColor: UIColor.lightGray,
            .paragraphStyle: paragraphStyle
        ]
        
        let topInset: CGFloat = 8.0
        let lineHeight = textFont.lineHeight
        
        // 텍스트와 라인 번호의 베이스라인을 맞추기 위한 보정값 계산
        let baselineOffset = (textFont.lineHeight - numberFont.lineHeight) / 2
        
        let lines = text.components(separatedBy: "\n")
        let horizontalPadding: CGFloat = 12
        
        for (i, _) in lines.enumerated() {
            let numberString = "\(i + 1)"
            // 각 줄의 y좌표에 베이스라인 보정값 추가
            let yPosition = CGFloat(i) * lineHeight - contentOffset.y + topInset + baselineOffset
            if yPosition + numberFont.lineHeight > 0 && yPosition < rect.height {
                let drawRect = CGRect(x: horizontalPadding,
                                      y: yPosition,
                                      width: rect.width - 2 * horizontalPadding,
                                      height: numberFont.lineHeight)
                numberString.draw(in: drawRect, withAttributes: attributes)
            }
        }
    }
}

class LineNumberTextView: UIView, UITextViewDelegate, UIScrollViewDelegate {
    let textView = UITextView()
    let lineNumberView = LineNumberView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // 텍스트뷰에는 14픽셀 글꼴 사용
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        lineNumberView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineNumberView)
        
        NSLayoutConstraint.activate([
            lineNumberView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineNumberView.topAnchor.constraint(equalTo: topAnchor),
            lineNumberView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineNumberView.widthAnchor.constraint(equalToConstant: 40),
            
            textView.leadingAnchor.constraint(equalTo: lineNumberView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // 스크롤 시 라인번호 뷰 업데이트
        textView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lineNumberView.contentOffset = scrollView.contentOffset
        lineNumberView.setNeedsDisplay()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lineNumberView.text = textView.text
        lineNumberView.setNeedsDisplay()
    }
}
