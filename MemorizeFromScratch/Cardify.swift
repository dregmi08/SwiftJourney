//
//  Cardify.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 8/4/24.
//

import SwiftUI

struct Cardify: ViewModifier {
    
    var isFaceUp: Bool
    var isMatched: Bool
    let cardColor: String
    
    func body(content: Content) -> some View {
        
        if(isFaceUp && !isMatched) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder()
                    .background(.white)
                    .foregroundColor(themeColorSetter(cardColor))
                    .overlay(content)
            }
        }
        else if (isMatched) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        else {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .overlay(Text(" "))
            }
            .foregroundColor(themeColorSetter(cardColor))
            .font(.largeTitle)
            
        }
        
    }
}

extension View {
    func cardify(isFaceUp: Bool, isMatched: Bool, cardColor: String) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched, cardColor: cardColor))
    }
}
