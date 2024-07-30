//
//  MemorizeFromScratchApp.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 6/26/24.
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
