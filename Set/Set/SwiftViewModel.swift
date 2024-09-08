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
    
    var deck: [SetModel.Card] {model.deck}
    
    var selected: [SetModel.Card] {model.selected}
    
    var displayed: [SetModel.Card] {model.displayed}
    
    var matchPile: [SetModel.Card] {model.matchPile}
      
    
    //MARK: - Intents
    
    func choose(_ card: SetModel.Card) {
        model.choose(card)
    }
    
    func deal() {
        model.deal()
    }
    
    func newGame() {
        model = SwiftViewModel.createNewSetGame()
    }

}
