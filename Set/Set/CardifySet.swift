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
    var isDealt: Bool
    var isMatched = false
    let numShapes: Int
    let shading: String
    
    //shapes : for now, circle, rounded rectangle, diamond
    func body(content: Content) -> some View {
        let roundedRectangle = RoundedRectangle(cornerRadius: 12.0)
        
        ZStack {
            roundedRectangle
                .stroke(cardColorDecider(color, isSelected, isMatched), lineWidth: 2)
                .background(Color.white)
                .overlay(content)
            roundedRectangle.fill(cardColorDecider(color, isSelected, isMatched)).opacity(isDealt ? 0 : 1)
        }
        
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
                return Color(red: 0.0, green: 0.5, blue: 0.7) 
            case "pink":
                return Color(red: 0.93, green: 0.5, blue: 0.6) 
            case "green":
                return Color(red: 0.55, green: 0.65, blue: 0.50) 
            default:
                return .pink
            }
        }
    }
}

extension View {
    func cardifyset(color: String, id: String, shape: String, numShapes: Int, shading: String, isSelected: Bool, isDealt: Bool, isMatched: Bool) -> some View {
        modifier(CardifySet(id: id, shape: shape, color: color,
                            isSelected: isSelected, isDealt: isDealt, isMatched: isMatched, numShapes: numShapes, shading: shading))
    }
}
