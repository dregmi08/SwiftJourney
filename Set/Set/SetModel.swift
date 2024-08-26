//
//  SetModel.swift
//  Set
//
//  Created by Drishti Regmi on 8/5/24.
//

import Foundation

struct SetModel {
    
    private(set) var score = 0
    
    private(set) var cards : [Card] = []
    
    private (set) var currentlySelected : [Card] = []
    
    private (set) var cardsCurrentlyDealt: [Card] = []
    
    private (set) var cardsMatched : [Card] = []
   
    init() {
        for attributeIndex in 1...27 {
            let shapeNum = (attributeIndex % 3) == 0 ? 3 : (attributeIndex % 3)
            let color = (attributeIndex % 9) < 3 ? "blue" : ((attributeIndex % 9) < 6 ? "purple" : "pink")
            let shading = (attributeIndex % 27) < 9 ? "solid" : ((attributeIndex % 27) < 18 ? "shaded" : "striped")
            
            let (card1, card2, card3) = (Card(id: "\(attributeIndex)a", shape: "circle", color: color, numShapes: shapeNum, shading: shading),  Card(id: "\(attributeIndex)b", shape: "diamond", color: color, numShapes: shapeNum, shading: shading),  Card(id: "\(attributeIndex)c", shape: "rounded-rect", color: color, numShapes: shapeNum, shading: shading))
            
            cards.append(card1)
            cards.append(card2)
            cards.append(card3)
        }
        print(cards)
        cards.shuffle()
        cardsCurrentlyDealt.append(contentsOf: cards.prefix(12))
        cards.removeFirst(12)
    }
    
    struct Card : Equatable, Identifiable {
        let id: String
        let shape: String
        let color : String
        var isSelected : Bool = false
        var isMatched = false
        let numShapes: Int
        let shading: String
    }
    
    mutating func selectCard(_ card: Card) {
        
        //first, grab the index of the selected card from the cards currently dealt array
        if let indexOfSelected = cardsCurrentlyDealt.firstIndex(where: {$0.id == card.id}) {
            cardsCurrentlyDealt[indexOfSelected].isSelected = true
            currentlySelected.append(cardsCurrentlyDealt[indexOfSelected])
            
            
            //if a set is already formed from the cards currently selected, then indicate
            //on the screen that three have been selected
            if(setFormed()) {
                if(currentlySelected.count == 4) {
                    replaceOrRemoveCards(cardsMatched[cardsMatched.count - 1], 
                                         cardsMatched[cardsMatched.count - 2], cardsMatched[cardsMatched.count - 3])
                }
                else{
                    currentlySelected.prefix(3).forEach { card in
                        if let indexOfSetMember = cardsCurrentlyDealt.firstIndex(where: {$0.id == card.id}) {
                            cardsMatched.append(cardsCurrentlyDealt[indexOfSetMember])
                            cardsCurrentlyDealt[indexOfSetMember].isMatched = true
                        }
                    }
                }
            }
           else if(!setFormed() && currentlySelected.count == 4) {
               currentlySelected.prefix(3).forEach { card in
                  deselect(card)
               }
           }
        }
    }
    
    //deselects the card and removes it from the cardsCurrently selected array
    mutating func deselect(_ card: Card) {
            if let cardIndexToDeselect = cardsCurrentlyDealt.firstIndex (where: {$0.id == card.id}) {
                cardsCurrentlyDealt[cardIndexToDeselect].isSelected.toggle()
                if let cardToRemoveFromSelected = currentlySelected.firstIndex(where: {$0.id == card.id}) {
                    currentlySelected.remove(at: cardToRemoveFromSelected)
                }
            }
    }
    
    //replaces three cards
    mutating func replaceOrRemoveCards(_ card1: Card, _ card2: Card, _ card3: Card) {
        let cardsToReplace = [card1, card2, card3]
        
        if cards.count != 0 {
            cardsToReplace.forEach { card in
                if let indexToReplace = cardsCurrentlyDealt.firstIndex(where: { $0.id == card.id }) {
                    if !cards.isEmpty {
                        cardsCurrentlyDealt[indexToReplace] = cards.removeFirst()
                    }
                }
            }
        } else {
            cardsToReplace.forEach { card in
                if let indexToRemove = cardsCurrentlyDealt.firstIndex(where: { $0.id == card.id }) {
                    cardsCurrentlyDealt.remove(at: indexToRemove)
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
        if (currentlySelected.count < 3 || !setFormed()) {
            (1...3).forEach { index in
                cardsCurrentlyDealt.append(cards[index])
                cards.remove(at: 1)
            }
        }
        else if (setFormed()) {
            replaceOrRemoveCards(currentlySelected[1],currentlySelected[2], currentlySelected[3])
        }
        
    }
}

