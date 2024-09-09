//
//  CardifySet.swift
//  Set
//
//  Created by Drishti Regmi on 8/6/24.
//

import SwiftUI

typealias Shapes = SetModel.Shapes
typealias Colors = SetModel.Colors
typealias Shading = SetModel.Shading

struct CardifySet: ViewModifier {
    
    
    let id: String
    let shape: Shapes
    let color : Colors
    var isSelected : Bool = false
    var isDealt: Bool
    var isMatched = false
    let numShapes: Int
    let shading: Shading
    
    //shapes : for now, circle, rounded rectangle, diamond
    func body(content: Content) -> some View {
        let roundedRectangle = RoundedRectangle(cornerRadius: 20.0)
        
        ZStack {
            roundedRectangle
                .stroke(cardColorDecider(color, isSelected, isMatched), lineWidth: 5)
                .blur(radius: isMatched ? 2 : 0) // Bright glowing effect
                .background(Color.white)
                .overlay(content)
            roundedRectangle.fill(cardColorDecider(color, isSelected, isMatched)).opacity(isMatched || isDealt ? 0 : 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .rotationEffect(Angle(degrees: isMatched ? 360 : 0)) // Apply rotation
        .animation(.easeInOut(duration: 1.0), value: isMatched)
        
    }
    
    func cardColorDecider(_ color: Colors, _ isSelected: Bool, _ isMatched: Bool) -> Color {
     if isMatched {
            return Color(red: 0.0, green: 0.5, blue: 0.0)
        }
        else if isSelected {
            return .cyan
        }
        else {
            return shapeColor(color)
        }
    }
}

extension View {
    func cardifyset(color: Colors, id: String, shape: Shapes, numShapes: Int, shading: Shading, isSelected: Bool, isDealt: Bool, isMatched: Bool) -> some View {
        modifier(CardifySet(id: id, shape: shape, color: color,
                            isSelected: isSelected, isDealt: isDealt, isMatched: isMatched, numShapes: numShapes, shading: shading))
    }
}
