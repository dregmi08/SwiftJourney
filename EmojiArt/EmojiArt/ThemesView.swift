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
    
    @State private var showThemeEditor = false
    
    @State private var showThemeList = false
    
    var body: some View {
        HStack {
            themePicker 
            view(for: store.themes[store.correctedCursorIdx])
        }
        .clipped()
        .sheet(isPresented: $showThemeEditor) {
            ThemeEditor(theme: $store.themes[store.correctedCursorIdx])
                .font(nil)
        } 
        .sheet(isPresented: $showThemeList) {
            NavigationStack {
                EditableThemeList(store: store)
                    .font(nil)
            }
        }
    }
    
    var themePicker: some View {
        AnimatedActionButton(systemImage: "paintpalette.fill") {
            store._cursorIdx += 1
        }
        .contextMenu {
            themeMenu
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "", emojis: "")
                showThemeEditor = true
            }
            
            AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive) {
                store.themes.remove(at: store.correctedCursorIdx)
            }
            
            AnimatedActionButton("Edit", systemImage: "pencil", role: .destructive) {
                showThemeEditor = true
            }
            
            AnimatedActionButton("List", systemImage: "list.bullet.rectangle.portrait", role: .destructive) {
                showThemeList = true
            }
        }
    }
    
    private var themeMenu : some View {
        Menu {
            ForEach(store.themes) { theme in
                AnimatedActionButton(theme.themeName) {
                    if let index = store.themes.firstIndex(where: {theme.id == $0.id}) {
                        store.correctedCursorIdx  = index
                    }
                }
            }
        }
        label : {
            Label("Go To", systemImage: "text.insert")
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
