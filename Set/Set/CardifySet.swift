//
//  CardifySet.swift
//  Set
//
//  Created by Drishti Regmi on 8/6/24.
//

import SwiftUI

struct CardifySet: ViewModifier {
    
    let id: String
    let shape: String
    let color : String
    var isSelected : Bool = false
    var isMatched = false
    let numShapes: Int
    let shading: String
    
    //shapes : for now, circle, rounded rectangle, diamond
    func body(content: Content) -> some View {

        ZStack {
            RoundedRectangle(cornerRadius: 12.0)
                .stroke(cardColorDecider(color, isSelected, isMatched), lineWidth: 2)
        }
        .background(Color.white)
        .overlay(content)
    }
    
    func cardColorDecider(_ color: String, _ isSelected: Bool, _ isMatched: Bool) -> Color {
        if isMatched {
            return .green
        }
        else if isSelected {
            return .cyan
        }
        else {
            switch color {
            case "blue":
                return .blue
            case "pink":
                return .pink
            case "purple":
                return .purple
            default:
                return .pink
            }
        }
    }
}


extension View {
    func cardifyset(color: String, id: String, shape: String, numShapes: Int, shading: String, isSelected: Bool, isMatched: Bool) -> some View {
        modifier(CardifySet(id: id, shape: shape, color: color,
                            isSelected: isSelected, isMatched: isMatched, numShapes: numShapes, shading: shading))
    }
}
