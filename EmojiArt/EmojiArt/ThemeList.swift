//
//  ThemeList.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 9/13/24.
//

import SwiftUI
struct EditableThemeList: View {
    
    @ObservedObject var store : EmojiThemesStore
    @State private var showCursorPalette = false
    
    var body: some View {
            List {
                ForEach (store.themes) { theme in
                    NavigationLink(value: theme.id) {
                        VStack(alignment: .leading) {
                            Text(theme.themeName)
                            Text(theme.emojis).lineLimit(1)
                        }
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        store.themes.remove(atOffsets: indexSet)
                    }
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationDestination(for: EmojiThemes.ID.self) { theme in
                if let index = store.themes.firstIndex(where: {theme == $0.id}) {
                    ThemeEditor(theme: $store.themes[index])
                }
            }
            .navigationDestination(isPresented: $showCursorPalette) {
                ThemeEditor(theme: $store.themes[store.correctedCursorIdx])
            }
            .navigationTitle("\(store.themeName) themes")
            .toolbar {
                Button {
                    store.insert(name: "", emojis: "" )
                    showCursorPalette = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        
    }
}


struct EmojiThemesView : View {
    let theme : EmojiThemes
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    NavigationLink(value: emoji) {
                        Text(emoji)
                    }
                }
            }
            .navigationDestination(for: String.self) { emoji in
                Text(emoji).font(.system(size: 300))
            }
            Spacer()
        }
        .padding()
        .font(.largeTitle)
        .navigationTitle(theme.themeName)
    }
}
