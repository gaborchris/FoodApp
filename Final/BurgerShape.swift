//
//  BurgerShape.swift
//  Final
//
//  Created by Christian Gabor on 6/10/20.
//  Copyright © 2020 Christian Gabor. All rights reserved.
//

import SwiftUI

struct Burger: Shape {
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let topBunLeft = CGPoint (
            x: center.x - rect.width / 2,
            y: center.y - rect.height * 1 / 8
        )
        let topBunRight = CGPoint (
            x: center.x + rect.width / 2,
            y: center.y - rect.height * 1 / 8
        )
        
        let topBunCenter = CGPoint (
            x: center.x,
            y: center.y - rect.height * 1 / 8
        )
        
        let radius = rect.width / 2
        
        
        
        let pattyLeftTop = CGPoint (
            x: center.x - rect.width / 2,
            y: center.y - rect.height / 8 + rect.height / 10
        )
        let pattyRightTop = CGPoint (
            x: center.x + rect.width / 2,
            y: center.y - rect.height / 8 + rect.height / 10
        )
        let pattyLeftBottom = CGPoint (
            x: center.x - rect.width / 2,
            y: center.y + rect.height / 8
        )
        let pattyRightBottom = CGPoint (
            x: center.x + rect.width / 2,
            y: center.y + rect.height / 8
        )
        
        let bottomBunLeftTop = CGPoint (
            x: center.x - rect.width / 2,
            y: center.y - rect.height * 2 / 8 + rect.height/2 - rect.height / 28
        )
        let bottomBunRightTop = CGPoint (
            x: center.x + rect.width / 2,
            y: center.y - rect.height * 2 / 8 + rect.height/2 - rect.height / 28
        )
        let bottomBunLeftBottom = CGPoint (
            x: center.x - rect.width / 2,
            y: center.y + rect.height/2 - rect.height / 28
        )
        let bottomBunRightBottom = CGPoint (
            x: center.x + rect.width / 2,
            y: center.y + rect.height/2 - rect.height / 28
        )
        
        
        
        
        
        var p = Path()
        
        p.move(to: topBunRight)
        p.addLine(to: topBunLeft)
        p.addArc(center: topBunCenter, radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 0), clockwise: false)
        
        p.move(to: pattyLeftTop)
        p.addLine(to: pattyRightTop)
        p.addLine(to: pattyRightBottom)
        p.addLine(to: pattyLeftBottom)
        p.addLine(to: pattyLeftTop)
        
        p.move(to: bottomBunLeftTop)
        p.addLine(to: bottomBunRightTop)
        p.addLine(to: bottomBunRightBottom)
        p.addLine(to: bottomBunLeftBottom)
        p.addLine(to: bottomBunLeftTop)
        return p
    }
    
}
