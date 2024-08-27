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
        .cardifyset(color: card.color, id: card.id, shape: card.shape, numShapes: card.numShapes, shading: card.shading, isSelected: card.isSelected, isMatched: card.isMatched)
    }
    
    private func cardshapeView(_ shape: String, _ shading: String) -> AnyView {
        var shapeView: AnyView
        let color = shapeColorDecider(card.color)
        switch(shape) {
        case "circle" :
            shapeView = AnyView(Circle().fill(color))
        case "rounded-rect" :
            shapeView = AnyView(RoundedRectangle(cornerRadius: 7.0).fill(color))
        case "diamond" :
            shapeView = AnyView(Diamond().fill(color))
        default :
            shapeView = AnyView(Diamond())
        }
        
        return shapeView
    }
        
    private func cardView(_ shading: String) -> AnyView {
        let color = shapeColorDecider(card.color)

        switch shading {
        case "solid":
            return AnyView(cardshapeView(card.shape, shading))

        case "striped":
            return AnyView(stripedShapeView(card.shape, color: color))

        case "shaded":
            return AnyView(cardshapeView(card.shape, shading).opacity(0.4))

        default:
            return AnyView(cardshapeView(card.shape, shading).opacity(0.4))
        }
    }

    private func stripedShapeView(_ shape: String, color: Color) -> AnyView {
        let stripeView = Stripes().stroke(color, lineWidth: 2)
        
        switch shape {
        case "diamond":
            return AnyView(ZStack {
                Diamond().stroke(color, lineWidth: 2)
                stripeView.clipShape(Diamond())
            })
            
        case "rounded-rect":
            let roundedRect = RoundedRectangle(cornerRadius: 7.0)
            return AnyView(ZStack {
                roundedRect.stroke(color, lineWidth: 2)
                stripeView.clipShape(roundedRect)
            })
            
        case "circle":
            return AnyView(ZStack {
                Circle().stroke(color, lineWidth: 2)
                stripeView.clipShape(Circle())
            })
            
        default:
            return AnyView(EmptyView())
        }
    }
    //color decider
    func shapeColorDecider(_ color: String) -> Color {
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

