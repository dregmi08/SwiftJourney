//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Drishti Regmi on 6/24/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
