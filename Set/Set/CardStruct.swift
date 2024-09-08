//
//  CardStruct.swift
//  Set
//
//  Created by Drishti Regmi on 8/14/24.
//

import SwiftUI

struct CardStruct: View {
    
    var card: SetModel.Card
    
    init(_ card: SetModel.Card) {
        self.card = card
    }
    
    var body: some View {
        VStack {
            ForEach(1...card.numShapes, id: \.self) { _ in
                cardView(card.shading).aspectRatio(2, contentMode: .fit)
            }
        }
        .padding()
        .cardifyset(color: card.color, id: card.id, shape: card.shape, numShapes: card.numShapes, shading: card.shading, isSelected: card.isSelected, isDealt: card.isDealt, isMatched: card.isMatched)
    }
    
    private func cardShapeView(_ shape: Shapes, _ shading: Shading, _ color : Colors) -> AnyView {
        
        var shapeView: AnyView
        let color = shapeColor(color)
        
        switch(shape) {
        case .circle :
            shapeView = AnyView(Circle().fill(color))
        case .rectangle :
            shapeView = AnyView(RoundedRectangle(cornerRadius: 7.0).fill(color))
        case .diamond :
            shapeView = AnyView(Diamond().fill(color))
        }
        return shapeView
    }
        
        func cardView(_ shading: Shading) -> AnyView {
            
            switch shading {
            case .solid:
                return AnyView(cardShapeView(card.shape, shading, card.color))
            case .striped:
                return AnyView(stripedShapeView(card.shape, color: card.color))
            case .shaded:
                return AnyView(cardShapeView(card.shape, shading, card.color).opacity(0.4))
            }
            
            func stripedShapeView(_ shape: Shapes, color: Colors) -> AnyView {
                let stripeView = Stripes().stroke(shapeColor(color), lineWidth: 2)
                
                switch shape {
                case .diamond:
                    return AnyView(ZStack {
                        Diamond().stroke(shapeColor(color), lineWidth: 2)
                        stripeView.clipShape(Diamond())
                    })
                    
                case .rectangle:
                    let roundedRect = RoundedRectangle(cornerRadius: 7.0)
                    return AnyView(ZStack {
                        roundedRect.stroke(shapeColor(color), lineWidth: 2)
                        stripeView.clipShape(roundedRect)
                    })
                    
                case .circle:
                    return AnyView(ZStack {
                        Circle().stroke(shapeColor(color), lineWidth: 2)
                        stripeView.clipShape(Circle())
                    })
                }
            }
        }
    }

func shapeColor(_ color: Colors) -> Color {
    switch color {
    case .blue:
        return Color(red: 0.0, green: 0.5, blue: 0.7)
    case .pink:
        return Color(red: 0.93, green: 0.5, blue: 0.6)
    case .green:
        return Color(red: 0.55, green: 0.65, blue: 0.50)
    }
}


