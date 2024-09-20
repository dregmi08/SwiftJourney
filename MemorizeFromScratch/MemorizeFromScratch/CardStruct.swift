//
//  CardStruct.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 8/3/24.
//

import SwiftUI

struct CardStruct: View{
    typealias Card = MemoryGame<String>.Card

    let card : Card
   
    init(_ card: Card) {
        self.card = card
    }
    
    
    var body: some View {
       //create rounded rectangle
       //param for emoji
        TimelineView(.animation) { timeline in
            if(!card.isMatched) {
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(0.4)
                    .padding(2)
                    .overlay(textContent)
                    .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched, cardColor: "blue")
                    .transition(.scale)
            }
            else {
                Color.clear
            }
        }
   }
    
    var textContent: some View {
        Text(card.content)
            .font(.system(size: 200))
            .minimumScaleFactor(0.01)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(0.5), value: card.isMatched)
    }
}



extension Animation {
    static func spin(_ duration: TimeInterval) -> Animation {
        .linear(duration: duration)
    }
}
