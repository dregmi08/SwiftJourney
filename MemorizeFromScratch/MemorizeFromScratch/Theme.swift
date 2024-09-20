//
//  Theme.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 7/25/24.
//

import Foundation
import SwiftUI

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var color: RGBA
    var emojiSet: String
    var numOfPairs: Int = 0
    let id: UUID

    static let inbuiltThemes : [Theme] = [
        Theme(name: "Halloween",
              color: RGBA(color: Color(red: 255, green: 165, blue: 0)),
              emojiSet:  "👻🎃🕷️😈💀🕸️🧙🏽🙀👹😱☠️🍭", numOfPairs: 12,
              id: UUID()),
        
        Theme(name: "Nature",
              color: RGBA(color: Color(red: 34, green: 139, blue: 34)),
              emojiSet: "🌲🌳🌴🌵🌷🌸🌹🌻🌼🌺🍁🍃", numOfPairs: 12,
              id: UUID()),
        
        Theme(name: "Music",
              color: RGBA(color: Color(red: 75, green: 0, blue: 75)),
              emojiSet:  "🎵🎶🎼🎹🎷🎸🎺🎻🥁🎤🎧📯", numOfPairs: 12,
              id: UUID()),
        
        Theme(name: "Travel",
              color: RGBA(color: Color(red: 128, green: 0, blue: 0)),
              emojiSet: "✈️🚂🚗🚢🏖️🏝️🗽🗼🗺️🏔️🛳️🧳", numOfPairs: 12,
              id: UUID()),
        
        Theme(name: "Tech",
              color: RGBA(color: Color(red: 128, green: 128, blue: 128)),
              emojiSet:  "💻🖥️📱⌨️🖱️🖲️💾📡🔋📷🎥🕹️", numOfPairs: 12,
              id: UUID()),
        
        Theme(name: "Animals",
              color: RGBA(color: Color(red: 101, green: 67, blue: 33)),
              emojiSet: "🐶🐱🐭🐹🐰🦊🐸🦄🦉🐨🐯🦁", numOfPairs: 12,
              id: UUID())
    ]
}

struct RGBA: Codable, Equatable, Hashable {
     let red: Double
     let green: Double
     let blue: Double
     let alpha: Double
}
