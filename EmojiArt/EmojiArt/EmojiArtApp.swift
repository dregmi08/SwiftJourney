//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 8/29/24.
//

import SwiftUI

@main
struct EmojiArtApp: App {

    var body: some Scene {
        DocumentGroup(newDocument: {EmojiArtDocument()}) { config in
            EmojiArtDocumentView(document: config.document)
        }
    }
}
