//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 8/29/24.
//

import Foundation

struct EmojiArt: Codable {
    
    var background: URL?
    private(set) var emojis = [Emoji]()
    
    static private var uniqueEmojiIdentification: Int = 0
    
    mutating func addEmoji(position: CGPoint, size: Int, _ emoji : String) {
        emojis.append(Emoji(string: emoji, position: position, size: CGFloat(size)))
    }

    mutating func moveEmoji(offset: CGOffset, id: Emoji.ID) {
        if let emojiIdx = emojis.firstIndex(where: {id == $0.id}) {
            emojis[emojiIdx].position.x = (CGFloat(emojis[emojiIdx].position.x) + offset.width)
            emojis[emojiIdx].position.y = (CGFloat(emojis[emojiIdx].position.y) + offset.height)
        }
    }
    
     func json () throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    
    init() {
        
    }
    
    struct Emoji: Identifiable, Codable{
        var id = UUID()
        let string: String
        var position: CGPoint
        var size: CGFloat
    }
    
    mutating func resizeEmoji( _ pinchScale: CGFloat, _ id: Emoji.ID) {
        if let resizeAtIdx = emojis.firstIndex(where: {$0.id == id}) {
            emojis[resizeAtIdx].size = CGFloat(emojis[resizeAtIdx].size) * pinchScale
        }
    }
}
