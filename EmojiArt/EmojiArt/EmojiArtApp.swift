//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 8/29/24.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var store = EmojiThemesStore(themeName: "main")
    @StateObject var store2 = EmojiThemesStore(themeName: "alternate")
    @StateObject var store3 = EmojiThemesStore(themeName: "creative")

    var body: some Scene {
        WindowGroup {
            ThemeManager(stores: [store, store2, store3])
            //EmojiArtDocumentView(document: defaultDocument)
            .environmentObject(store)
        }
    }
}
