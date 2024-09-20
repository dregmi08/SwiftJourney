//
//  EmojiMemoryGame.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 7/5/24.
//
//this is the view model
import SwiftUI

class EmojiMemoryGame : ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    var theme: Theme
    
    @Published private var model : MemoryGame<String>
    
    init(_ gameTheme: Theme) {
        theme = gameTheme
        model = EmojiMemoryGame.createMemoryGame(gameTheme)
    }
    
    private static func createMemoryGame(_ theme: Theme) -> MemoryGame<String> {
        let emojiArr = Array(theme.emojiSet)
        
        return MemoryGame(numOfCardPairs: theme.numOfPairs) { pairIndex in
            if emojiArr.indices.contains(pairIndex) {
                return String(emojiArr[pairIndex]) // Convert Character to String
            } else {
                return "﹖﹗" // Fallback emoji
            }
        }
    }
    
    var cards: Array<Card> {
        return model.cards
    }
   
    var themeName: String {
        return theme.name
    }
    
    var score: Int { model.score }
    // MARK: - Intents
    
     func shuffle() {
         model.shuffle()
    }
    
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame(theme)
    }

    func choose(_ card: Card){
        model.choose(card)
    }
    
}
