//
//  Diamond.swift
//  Set
//
//  Created by Drishti Regmi on 8/25/24.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let topMiddle = CGPoint(x: rect.midX, y: rect.minY)
        let rightCorner = CGPoint(x: rect.maxX, y: rect.midY)
        let bottomMiddle = CGPoint(x: rect.midX, y: rect.maxY)
        let leftCorner = CGPoint(x: rect.minX, y: rect.midY)
        
        var path = Path()
        path.move(to: topMiddle)
        path.addLine(to: rightCorner)
        path.addLine(to: bottomMiddle)
        path.addLine(to: leftCorner)
        path.addLine(to: topMiddle)
        
        return path
    }
    
}

