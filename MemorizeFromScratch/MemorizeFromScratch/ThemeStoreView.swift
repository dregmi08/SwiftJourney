//
//  ThemeChooser.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 9/14/24.
//

import SwiftUI

struct ThemeStoreView: View {
    
    @EnvironmentObject var store : ThemeStore
    @State var editTheme = false
    @State var selectedTheme : Theme?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (store.themes) { theme in
                    NavigationLink (value : theme) {
                        themeListView(theme: theme)
                            .gesture(editTheme ? tapGesture(theme: theme) : nil)
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        store.themes.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationDestination(for: Theme.self) { theme in
                if let chosenThemeIdx = store.themes.firstIndex(where: {theme.id == $0.id}) {
                    EmojiMemoryGameView(viewModel: EmojiMemoryGame(store.themes[chosenThemeIdx]))
                }
            }
            .sheet(item: $selectedTheme) { theme in
                if let themeInStore = store.themes.firstIndex(where: {theme.id == $0.id}) {
                    ThemeEditor(theme: $store.themes[themeInStore])
                }
            }
            .navigationTitle("Memorize Themes")
            .toolbar {
                addThemeButton
                editButton
            }
        }
    }
    
    private func tapGesture(theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                if let themeIdx = store.themes.firstIndex(where: {$0.id == theme.id}) {
                    selectedTheme = store.themes[themeIdx]
                }
            }
    }

    private var editButton : some View {
        Button {
            editTheme.toggle()
        } label: {
            Image(systemName: "pencil")
                .foregroundColor(editTheme ? .red : .black)
        }
    }
    
    private var addThemeButton : some View {
        Button {
            store.themes.append(Theme(name: "", color: RGBA(red: 75, green: 0, blue: 75, alpha: 1.0), emojiSet: "", id: UUID()))
            selectedTheme = store.themes.last
        } label: {
            Image(systemName: "plus")
        }
    }
    
    func themeListView(theme: Theme) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(theme.name)")
                    .font(.headline)
                Circle().foregroundColor(Color(rgba: theme.color)).frame(minWidth: 15, maxWidth: 20, minHeight: 15, maxHeight: 20)
            }
            Text("Emoji Set : \(theme.emojiSet)").lineLimit(1)
            
            Text("Card Pairs: \(theme.numOfPairs)")
                .font(.subheadline)
        }
    }
}

func arrayToString(_ emojiSet: [String]) -> String {
    var emojiString = ""
    for emoji in emojiSet {
        emojiString += emoji
    }
    return emojiString
}
