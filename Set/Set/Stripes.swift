//
//  Stripes.swift
//  Set
//
//  Created by Drishti Regmi on 8/24/24.
//

import SwiftUI

struct Stripes: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        //start at the top left and bottom left
        var lineTop = CGPoint(x: rect.minX, y: rect.minY)
        var lineBottom = CGPoint(x: rect.minX, y: rect.maxY)
      
        var path = Path()
    
        while(lineTop.x < rect.maxX) {
            path.move(to: lineTop)
            path.addLine(to: lineBottom)
            
            lineTop = CGPoint(x: lineTop.x + 4, y: lineTop.y)
            lineBottom = CGPoint(x: lineBottom.x + 4, y: lineBottom.y)
        }
        
        return path
    }
}
