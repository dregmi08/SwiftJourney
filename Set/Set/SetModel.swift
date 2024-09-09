//
//  SetModel.swift
//  Set
//
//  Created by Drishti Regmi on 8/5/24.
//

import Foundation

struct SetModel {
    
    private(set) var deck : [Card] = []
    private(set) var displayed : [Card] = []
    private (set) var selected : [Card] = []
    private (set) var matchPile : [Card] = []
        
    enum Shapes: Int, CaseIterable {
        case circle, rectangle, diamond
    }
    
    enum Colors: Int, CaseIterable {
        case blue, green, pink
    }
    
    enum Shading: Int, CaseIterable {
        case solid, shaded, striped
    }
    
    init() {
        for attributeIndex in 1...(Shapes.allCases.count * Colors.allCases.count
                                   * Shading.allCases.count) {
       
            let shapeNum = (attributeIndex % 3) == 0 ? 3 : (attributeIndex % 3)
            let color = (attributeIndex % 9) < 3 ? Colors.blue :
                ((attributeIndex % 9) < 6 ? Colors.green : Colors.pink)
            let shading = (attributeIndex % 27) < 9 ? Shading.solid : 
                ((attributeIndex % 27) < 18 ? Shading.shaded : Shading.striped)
            
            let (card1, card2, card3) = (Card(id: "\(attributeIndex)a", shape: Shapes.circle, color: color, numShapes: shapeNum, shading: shading),  Card(id: "\(attributeIndex)b", shape: Shapes.diamond, color: color, numShapes: shapeNum, shading: shading),  Card(id: "\(attributeIndex)c", shape: Shapes.rectangle, color: color, numShapes: shapeNum, shading: shading))
            
            
            deck.append(card1)
            deck.append(card2)
            deck.append(card3)
        }

        deck.shuffle()
        for i in 0...11 {
            deck[i].isDealt = true
            displayed.append(deck[i])
        }
        deck.removeFirst(12)
    }
    
    struct Card : Equatable, Identifiable {
        let id: String
        let shape: SetModel.Shapes
        let color : SetModel.Colors
        var isSelected : Bool = false
        var isMatched = false
        var isDealt = false
        let numShapes: Int
        let shading: SetModel.Shading
    }
    
    mutating func choose(_ card: Card) {            
            if(card.isSelected) {
                if let unselect = displayed.firstIndex(of: card) {displayed[unselect].isSelected.toggle()}
                if let removeIdx = selected.firstIndex(of: card) {selected.remove(at: removeIdx)}
            }
            else {
                selected.append(card)
                if let select = displayed.firstIndex(of: card) {displayed[select].isSelected.toggle()}
                
                if (selected.count >= 3 && setFormed(selected[0], selected[1], selected[2])) {
                    for card in selected.prefix(3) {
                        if let matched = displayed.firstIndex(where: {$0.id == card.id}) {
                            displayed[matched].isMatched = true
                        }
                    }
                    if(selected.count == 4) {
                        for card in selected.prefix(3) {
                            if let matched = displayed.firstIndex(where: {$0.id == card.id}) {
                                matchPile.append(displayed.remove(at: matched))
                            }
                        }
                        selected.removeFirst(3)
                    }
                }
                else if (selected.count == 4 && !setFormed(selected[0], selected[1], selected[2])) {
                    for card in selected.prefix(3) {
                        if let matched = displayed.firstIndex(where: {$0.id == card.id}) {
                            displayed[matched].isSelected.toggle()
                        }
                    }
                    selected.removeFirst(3)
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
    func setFormed(_ first: Card, _ second: Card, _ third : Card) -> Bool {
        guard selected.count >= 3 else {return false}
            
            return setShape(first, second, third) && setShade(first, second, third) 
                && setColor(first, second, third) && setNumShape(first, second, third)
    }
    
    mutating func deal() {
        guard !deck.isEmpty else {return}

        if(selected.count == 3 && setFormed(selected[0], selected[1], selected[2])) {
            let replacements = Array(deck.prefix(3))
            deck.removeFirst(3)
            for index in (0...2) {
                if let replacing = displayed.firstIndex(where: {selected[index].id == $0.id}) {
                    matchPile.append(displayed.remove(at: replacing))
                    displayed[replacing] = replacements[index]
                    displayed[replacing].isDealt = true
                }
            }
            selected = []
        }
        else if(selected.count < 3 || !setFormed(selected[0], selected[1], selected[2])) {
            let replacements = Array(deck.prefix(3))
            deck.removeFirst(3)
            for card in replacements {
                displayed.append(card)
                displayed[displayed.count-1].isDealt = true
            }
        }
    }
}
