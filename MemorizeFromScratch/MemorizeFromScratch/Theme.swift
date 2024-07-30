//
//  Theme.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 7/25/24.
//

import Foundation

struct Theme {
    
    let name: String
    let color: String
    let emojiSet: [String]
    let numPairs : Int
    
    init(name: String, color: String, emojiSet: [String], numPairs: Int) {
        self.name = name
        self.color = color
        self.emojiSet = emojiSet
        self.numPairs = numPairs
    }
    
}
