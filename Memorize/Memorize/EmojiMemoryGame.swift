//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Drishti Regmi on 6/30/24.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {
    private static var emojis : [String] { return ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙🏽", "🙀", "👹", "😱", "☠️", "🍭"]}
    
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return  MemoryGame(numOfPairs:10) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            }
            else {
                return "﹖﹗"
            }
        }
    }
    
    
    @Published private var model = createMemoryGame()
    
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    func shuffle() {
        model.shuffleCards()
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        model.chooseCard(card)
    }
  
}
