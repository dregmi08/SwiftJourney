//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 8/29/24.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            autosave()
        }
    }
    
    private let autosaveURL : URL = URL.documentsDirectory.appendingPathComponent("Autosaved.emojiArt")
    
    private func autosave() {
        save(to: autosaveURL)
        print("\(autosaveURL)")
    }
    
    private func save(to url: URL) {
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        }
        catch let error {
            print("EmojiArtDocument: error while saving \(error.localizedDescription)")
        }
    }
    
    init () {
        if let data = try? Data(contentsOf: autosaveURL),
           let autosavedEmojiArt = try? EmojiArt(json: data){
            emojiArt = autosavedEmojiArt
        }
    }
    
    var emojis : [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    func select(_ emoji: Emoji) {
        emojiArt.select(emoji)
    }
    
    //MARK: - Intents

    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
     func addEmoji(position: Emoji.Position, size: CGFloat, _ emoji : String){
        emojiArt.addEmoji(position: position, size: Int(size), emoji)
    }

}
