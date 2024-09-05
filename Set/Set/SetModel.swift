//
//  SetModel.swift
//  Set
//
//  Created by Drishti Regmi on 8/5/24.
//

import Foundation

struct SetModel {
    
    private(set) var score = 0
    
    private(set) var cardDeck : [Card] = []
    
    private (set) var currentlySelected : [Card] = []
    
    private (set) var cardsCurrentlyDealt: [Card] = []
    
    private (set) var cardsMatched : [Card] = []
    
    private (set) var allCards : [Card] = []
   
    init() {
        for attributeIndex in 1...27 {
            
            let shapeNum = (attributeIndex % 3) == 0 ? 3 : (attributeIndex % 3)
            let color = (attributeIndex % 9) < 3 ? "blue" : ((attributeIndex % 9) < 6 ? "green" : "pink")
            let shading = (attributeIndex % 27) < 9 ? "solid" : ((attributeIndex % 27) < 18 ? "shaded" : "striped")
            
            let (card1, card2, card3) = (Card(id: "\(attributeIndex)a", shape: "circle", color: color, numShapes: shapeNum, shading: shading),  Card(id: "\(attributeIndex)b", shape: "diamond", color: color, numShapes: shapeNum, shading: shading),  Card(id: "\(attributeIndex)c", shape: "rounded-rect", color: color, numShapes: shapeNum, shading: shading))
            
            cardDeck.append(card1)
            cardDeck.append(card2)
            cardDeck.append(card3)
        }

        cardDeck.shuffle()
        
        for i in 0...11 {
            cardDeck[i].isDealt = true
        }
        cardsCurrentlyDealt.append(contentsOf: cardDeck.prefix(12))
        allCards.append(contentsOf: cardDeck)
        cardDeck.removeFirst(12)
    }
    
    struct Card : Equatable, Identifiable {
        let id: String
        let shape: String
        let color : String
        var isSelected : Bool = false
        var isMatched = false
        var isDealt = false
        let numShapes: Int
        let shading: String
    }
    
 
    mutating func selectCard(_ card: Card) {
        
        //first, grab the index of the selected card from the cards currently dealt array
        if let indexOfSelected = cardsCurrentlyDealt.firstIndex(where: {$0.id == card.id}) {
            if(cardsCurrentlyDealt[indexOfSelected].isSelected == true) {
                deselect(card)
            }
            else {
                cardsCurrentlyDealt[indexOfSelected].isSelected = true
                currentlySelected.append(cardsCurrentlyDealt[indexOfSelected])
              
                //if a set is already formed from the cards currently selected, then indicate
                //on the screen that three have been selected
                if(setFormed()) {
                        currentlySelected.prefix(3).forEach { card in
                            if let indexOfSetMember = cardsCurrentlyDealt.firstIndex(where: {$0.id == card.id}) {
                                cardsMatched.append(cardsCurrentlyDealt[indexOfSetMember])
                                cardsCurrentlyDealt[indexOfSetMember].isMatched = true
                                cardsMatched[cardsMatched.count-1].isMatched = true
                            }
                        }
                        removeCards(cardsMatched[cardsMatched.count - 1],
                                            cardsMatched[cardsMatched.count - 2], cardsMatched[cardsMatched.count - 3])
                        currentlySelected.removeFirst(3)
                    
                }
                else if(!setFormed() && currentlySelected.count == 4) {
                    currentlySelected.prefix(3).forEach { card in
                        deselect(card)
                    }
                }
            }
        }
    }
    
    //deselects the card and removes it from the cardsCurrently selected array
    mutating func deselect(_ card: Card) {
            if let cardIndexToDeselect = 
                cardsCurrentlyDealt.firstIndex (where: {$0.id == card.id}) {
                cardsCurrentlyDealt[cardIndexToDeselect].isSelected.toggle()
                if let cardToRemoveFromSelected = 
                    currentlySelected.firstIndex(where: {$0.id == card.id}) {
                    currentlySelected.remove(at: cardToRemoveFromSelected)
                }
            }
    }
    
    //replaces three cards
    mutating func removeCards(_ card1: Card, _ card2: Card, _ card3: Card) {
           let cardsToReplace = [card1, card2, card3]
         
               cardsToReplace.forEach { card in
                   if let indexToRemove = 
                        cardsCurrentlyDealt.firstIndex(where: { $0.id == card.id }) {
                       cardsCurrentlyDealt.remove(at: indexToRemove)
                   }
               }
       }
    
    mutating func replaceCards(_ card1: Card, _ card2: Card, _ card3: Card) {
        let cardsToReplace = [card1, card2, card3]
        
        if cardDeck.count != 0 {
            cardsToReplace.forEach { card in
                if let indexToReplace = 
                    cardsCurrentlyDealt.firstIndex(where: { $0.id == card.id }) {
                    if !cardDeck.isEmpty {
                        cardsCurrentlyDealt[indexToReplace] = cardDeck.removeFirst()
                        cardsCurrentlyDealt[indexToReplace].isDealt = true
                    }
                }
            }
        }
    }
    
    //generic function that will compare three equatables, will return true if all values are the same
    //or if all are different
    func isSet<T: Equatable> (_ a: T, _ b: T, _ c: T) -> Bool {
        return !(((a == b  && (b != c)) || (a == c && a != b)) || (b == c && a != c))
    }
    
    //helpers for determining all set properties
    func setShape(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
        return isSet(card1.shape, card2.shape, card3.shape)
    }
    
    func setShade(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
        return isSet(card1.shading, card2.shading, card3.shading)
    }
    
    func setColor(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
        return isSet(card1.color, card2.color, card3.color)
    }
    
    func setNumShape(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
        return isSet(card1.numShapes, card2.numShapes, card3.numShapes)
    }
    
    //will check if set is formed from all cards currently selected
    mutating func setFormed() -> Bool {
        guard currentlySelected.count >= 3 else {return false}
                
            let (first, second, third) = (currentlySelected[0], currentlySelected[1], currentlySelected[2])
            
            return setShape(first, second, third) && setShade(first, second, third) 
                && setColor(first, second, third) && setNumShape(first, second, third)
    }
    
    //Not done yet, deal cards
    mutating func dealCards() {
        if(!cardDeck.isEmpty) {
            if (currentlySelected.count < 3 || !setFormed()) {
                (1...3).forEach { _ in
                    cardDeck[0].isDealt = true
                    if let indexInAllCards = allCards.firstIndex(where: {cardDeck[0].id == $0.id}) {
                        allCards[indexInAllCards].isDealt = true
                    }
                    cardsCurrentlyDealt.append(cardDeck[0])
                    cardDeck.removeFirst()
                }
            }
            else if (setFormed()) {
                replaceCards(currentlySelected[0],currentlySelected[1], currentlySelected[2])
                currentlySelected.removeFirst(3)
            }
        }
    }
}
