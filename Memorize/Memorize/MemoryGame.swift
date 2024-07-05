//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Drishti Regmi on 6/30/24.
//

import Foundation

struct MemoryGame<CardContent>  {
    private(set) var cards : Array<Card>
    
    init(numOfPairs: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        //add numofpairs x 2 to array
        
        for pairIndex in 0..<max(2, numOfPairs) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
      
    }
    
    
    func chooseCard(_ card: Card) {
       
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }
    
    struct Card {
        var isFaceUp = true
        var isMatched = false
        let content : CardContent
    }
    
  
}
