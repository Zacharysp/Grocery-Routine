//
//  ScanSquareLayer.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/19/22.
//

import UIKit

class ScanSquareLayer: CAShapeLayer {

    init(outsideRect: CGRect) {
        super.init()
        
        let xMargin = outsideRect.width * 0.1
        let squareWidth = outsideRect.width * 0.8
        let squareHeight = squareWidth * 0.618
        let yMargin = (outsideRect.height - squareHeight) * 0.5
        let lineLength: CGFloat = 20
        let curvedLineRadius: CGFloat = 20
        
        let path = UIBezierPath()
        
        // draw top left corner
        let topLeftStart = CGPoint(x: xMargin,
                                   y: yMargin + curvedLineRadius + lineLength)
        path.move(to: topLeftStart)
        path.addLine(to: CGPoint(x: topLeftStart.x,
                                 y: topLeftStart.y - lineLength))
        path.addArc(withCenter: CGPoint(x: topLeftStart.x + curvedLineRadius,
                                        y: topLeftStart.y - lineLength),
                    radius: curvedLineRadius,
                    startAngle: 0 - .pi,
                    endAngle: 0 - .pi * 0.5,
                    clockwise: true)
        path.addLine(to: CGPoint(x: topLeftStart.x + curvedLineRadius + lineLength,
                                 y: topLeftStart.y - curvedLineRadius - lineLength))
        
        // draw top right corner
        let topRightStart = CGPoint(x: outsideRect.width - xMargin - lineLength - curvedLineRadius,
                                    y: yMargin)
        path.move(to: topRightStart)
        path.addLine(to: CGPoint(x: topRightStart.x + lineLength,
                                 y: topRightStart.y))
        path.addArc(withCenter: CGPoint(x: topRightStart.x + lineLength,
                                        y: topRightStart.y + curvedLineRadius),
                    radius: curvedLineRadius,
                    startAngle: 0 - .pi * 0.5,
                    endAngle: 0,
                    clockwise: true)
        path.addLine(to: CGPoint(x: topRightStart.x + lineLength + curvedLineRadius,
                                 y: topRightStart.y + lineLength + curvedLineRadius))
        
        // draw bottom right corner
        let bottomRightStart = CGPoint(x: outsideRect.width - xMargin,
                                       y: outsideRect.height - yMargin - curvedLineRadius - lineLength)
        path.move(to: bottomRightStart)
        path.addLine(to: CGPoint(x: bottomRightStart.x,
                                 y: bottomRightStart.y + lineLength))
        path.addArc(withCenter: CGPoint(x: bottomRightStart.x - curvedLineRadius,
                                        y: bottomRightStart.y + lineLength),
                    radius: curvedLineRadius,
                    startAngle: 0,
                    endAngle: .pi * 0.5,
                    clockwise: true)
        path.addLine(to: CGPoint(x: bottomRightStart.x - lineLength - curvedLineRadius,
                                 y: bottomRightStart.y + lineLength + curvedLineRadius))
        
        // draw bottom left corner
        let bottomLeftStart = CGPoint(x: xMargin + curvedLineRadius + lineLength,
                                       y: outsideRect.height - yMargin)
        path.move(to: bottomLeftStart)
        path.addLine(to: CGPoint(x: bottomLeftStart.x - lineLength,
                                 y: bottomLeftStart.y))
        path.addArc(withCenter: CGPoint(x: bottomLeftStart.x - lineLength,
                                        y: bottomLeftStart.y - curvedLineRadius),
                    radius: curvedLineRadius,
                    startAngle: .pi * 0.5,
                    endAngle: .pi,
                    clockwise: true)
        path.addLine(to: CGPoint(x: bottomLeftStart.x - lineLength - curvedLineRadius,
                                 y: bottomLeftStart.y - lineLength - curvedLineRadius))
        
        
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = UIColor.white.withAlphaComponent(0.6).cgColor
        self.lineWidth = 6
        self.lineCap = .round
        self.path = path.cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
