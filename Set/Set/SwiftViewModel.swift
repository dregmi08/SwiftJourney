//
//  SwiftViewModel.swift
//  Set
//
//  Created by Drishti Regmi on 8/5/24.
//

import SwiftUI

class SwiftViewModel: ObservableObject {
    
    @Published private var model = createNewSetGame()

    private static func createNewSetGame() -> SetModel {
        return SetModel()
    }
    
    //variables
    
    var cardDeck: [SetModel.Card] {model.cardDeck}
    
    var score: Int {model.score}
    
    var currentlySelected: [SetModel.Card] {model.currentlySelected}
    
    var currentlyDealt: [SetModel.Card] {model.cardsCurrentlyDealt}
    
    var currentlyMatched: [SetModel.Card] {model.cardsMatched}
  
    var allCards : [SetModel.Card] {model.allCards}
    
    
    //MARK: - Intents
    
    func selectCard(_ card: SetModel.Card) {
        model.selectCard(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    func deselect(_ card: SetModel.Card) {
        model.deselect(card)
    }
    
    func newGame() {
        model = SwiftViewModel.createNewSetGame()
    }
    
    var setFormed : Bool
    {model.setFormed()}

}
