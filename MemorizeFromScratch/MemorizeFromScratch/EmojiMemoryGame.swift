//
//  EmojiMemoryGame.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 7/5/24.
//
//this is the view model
import SwiftUI

class EmojiMemoryGame : ObservableObject {

    private static let themeAttributes = [
        Theme(name: "Halloween",
              color: "orange",
              emojiSet:  ["👻", "🎃", "🕷️", "😈", 
                          "💀", "🕸️", "🧙🏽", "🙀",
                          "👹", "😱", "☠️", "🍭"],
              numPairs: 12),
        
        Theme(name: "Nature",
              color: "green",
              emojiSet: ["🌲", "🌳", "🌴", "🌵", 
                         "🌷", "🌸", "🌹", "🌻",
                         "🌼", "🌺", "🍁", "🍃"],
              numPairs: 12),
        
        Theme(name: "Music",
              color: "purple",
              emojiSet: [ "🎵", "🎶", "🎼", "🎹",
                          "🎷", "🎸", "🎺", "🎻",
                          "🥁", "🎤", "🎧", "📯"],
              numPairs: 12),
        
        Theme(name: "Travel",
              color: "red",
              emojiSet: [ "✈️", "🚂", "🚗", "🚢",
                          "🏖️", "🏝️", "🗽", "🗼",
                          "🗺️", "🏔️", "🛳️", "🧳"],
              numPairs: 12),
        
        Theme(name: "Tech",
              color: "grey",
              emojiSet: [ "💻", "🖥️", "📱", "⌨️",
                          "🖱️", "🖲️", "💾", "📡",
                          "🔋", "📷", "🎥", "🕹️"],
             numPairs: 12),
        
        Theme(name: "Animals",
              color: "brown",
              emojiSet: [ "🐶", "🐱", "🐭", "🐹",
                          "🐰", "🦊", "🐸", "🦄",
                          "🦉", "🐨", "🐯", "🦁"],
             numPairs: 12)
    ]
    
    

    private static func createMemoryGame( _ new_theme: Theme) -> MemoryGame<String> {
        let numShownPairs = Int.random(in: 8...new_theme.emojiSet.count)
        return  MemoryGame(theme: new_theme.name, numOfCardPairs: numShownPairs, themeCol: currTheme!.color) { pairIndex in
            if new_theme.emojiSet.indices.contains(pairIndex) {
                return new_theme.emojiSet[pairIndex]
            }
            else {
                return "﹖﹗"
            }
        }
    }
    
    static var currTheme = themeAttributes.randomElement()
    @Published private var model = createMemoryGame(currTheme!)
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
   
    var themeName: String {
        return EmojiMemoryGame.currTheme!.name
    }
    
    var themeColor: String {
        return EmojiMemoryGame.currTheme!.color
    }
    
    var score: Int { model.score }
    // MARK: - Intents
    
     func shuffle() {
         model.shuffle()
    }
    
    func newGame() {
        EmojiMemoryGame.currTheme = EmojiMemoryGame.themeAttributes.randomElement()
        model = EmojiMemoryGame.createMemoryGame(EmojiMemoryGame.currTheme!)
    }

    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
    

   
    
    
}
