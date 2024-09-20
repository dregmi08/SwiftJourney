//
//  MemorizeGame.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 7/5/24.
//

import Foundation
import SwiftUI


struct MemoryGame<CardContent> where CardContent : Equatable {
    //store all cards
    private(set) var cards: Array<Card>
    
    private var IndexOfTheOneAndOnlyFaceUpCard: Int?
    //num of card pairs
    private(set) var score = 0
    
    private(set) var hasBeenSeen: [Card] = []
    
    private(set) var currentlyFlippedOverandUnmatched: [Card] = []
    
    init(numOfCardPairs: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in (0..<numOfCardPairs) {
            cards.append(Card(content: cardContentFactory(pairIndex), id: "\(pairIndex+1)a"))
            cards.append(Card(content: cardContentFactory(pairIndex), id: "\(pairIndex+1)b"))
        }
        cards.shuffle()
    }
        
    struct Card: Equatable, Identifiable {
        let content: CardContent
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    isAlreadySeen = true
                }
            }
        }
        let id: String
        var isMatched  = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var isAlreadySeen = false
        
        // MARK: - Bonus Time
        
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var bonusTimeLimit: TimeInterval = 6
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        let faceUpCards = cards.indices.filter { cards[$0].isFaceUp && !cards[$0].isMatched }

        if(faceUpCards.count == 2) {
            for index in cards.indices {
                if(cards[index].isFaceUp && !cards[index].isMatched) {
                    cards[index].isFaceUp = false
                    cards[index].isAlreadySeen = true
                }
            }
        }
        
        if let chosenCard = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenCard].isMatched,
           !cards[chosenCard].isFaceUp {
            
            cards[chosenCard].isFaceUp = true
            
            if (faceUpCards.count == 1) {
                if let potentialMatch = cards.firstIndex(where: {$0.id == cards[faceUpCards[0]].id}) {
                    if(cards[chosenCard].content == cards[potentialMatch].content) {
                        score += 2 + cards[chosenCard].bonus + cards[potentialMatch].bonus
                        cards[chosenCard].isMatched = true
                        cards[potentialMatch].isMatched = true
                    }
                    else {
                        if(cards[potentialMatch].isAlreadySeen || cards[chosenCard].isAlreadySeen) {
                            score -= 1
                        }
                    }
                }
            }
        }
    }
}
