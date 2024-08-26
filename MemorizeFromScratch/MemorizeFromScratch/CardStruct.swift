//
//  CardStruct.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 8/3/24.
//

import SwiftUI

struct CardStruct: View {
    typealias Card = MemoryGame<String>.Card

    let card : Card
   
    init(_ card: Card) {
        self.card = card
    }
    
    
    var body: some View {
       //create rounded rectangle
       //param for emoji
        
            Pie(endAngle: .degrees(240))
                .opacity(0.4)
                .padding(2)
                .overlay {
                    Text(card.content)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .multilineTextAlignment(.center)
                        .aspectRatio(1, contentMode: .fit)
                }  .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched, cardColor: card.cardColor)
   }
}

struct CardStruct_Previews: PreviewProvider {
    typealias Card = CardStruct.Card

    static var previews: some View {
        CardStruct(Card(content: "X", cardColor: "red", id: "hi"))
            .padding()
    }
}
