//
//  ThemesView.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 9/9/24.
//

import SwiftUI

struct ThemesView: View {
    typealias Emoji = EmojiArt.Emoji
    
    @EnvironmentObject var store: EmojiThemesStore
    
    var body: some View {
        HStack {
            themePicker
            view(for: store.themes[store.correctedCursorIdx])
        }
        .clipped()
    }
    
    var themePicker: some View {
        AnimatedActionButton(systemImage: "paintpalette.fill") {
            store._cursorIdx += 1
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "+-=/")
            }
            AnimatedActionButton("Delete", systemImage: "minus.circle", role:.destructive) {
                store.themes.remove(at: store.correctedCursorIdx)
            }
        }
    }
    
    func view(for theme: EmojiThemes) -> some View {
        HStack {
            Text(theme.themeName)
            ScrollingEmojis(theme.emojis)
        }
        .id(theme.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
    
    struct ScrollingEmojis: View {
        let emojis: [String]
        
        init(_ emojis: String) {
            self.emojis = emojis.uniqued.map(String.init)
        }
        var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .draggable(emoji)
                    }
                }
            }
        }
    }
}
#Preview {
    ThemesView()
        .environmentObject(EmojiThemesStore(themeName: "Preview"))
}
