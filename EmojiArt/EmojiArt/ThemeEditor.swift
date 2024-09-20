//
//  ThemeEditor.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 9/13/24.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme : EmojiThemes
    
    @State private var emojisToAdd: String = ""
    
    private let emojiFont = Font.system(size: 40)
    
    enum Focused {
        case name
        case addEmojis
    }
    
    @FocusState private var focused: Focused?
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $theme.themeName)
                    .focused($focused, equals: .name)
            }
           
            Section(header: Text("Emojis")) {
                TextField("Add emojis here", text: $emojisToAdd)
                    .focused($focused, equals: .addEmojis)
                    .font(emojiFont)
                    .onChange(of: emojisToAdd) { emojisToAdd, oldValue in
                        theme.emojis = (emojisToAdd + theme.emojis)
                            .filter { $0.isEmoji }
                            .uniqued
                    }
                removeEmojis
            }
        }
        .frame(minWidth: 300, minHeight: 350)
        .onAppear {
            if theme.themeName.isEmpty {
                focused = .name
            } else {
                focused = .addEmojis
            }
        }
    }
    
    var removeEmojis : some View {
        VStack(alignment: .trailing) {
            Text("Tap to remove emojis").font(.caption).foregroundColor(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji) 
                    .onTapGesture {
                        if let removeIdx = theme.emojis.firstIndex(where: {String($0) == emoji}) {
                            theme.emojis.remove(at: removeIdx)
                            if let removeIdxAdd = emojisToAdd.firstIndex(where: {String($0) == emoji}) {
                                emojisToAdd.remove(at: removeIdxAdd)
                            }
                        }
                        
                    }
                }
            }
        }
        .font(emojiFont)
    }
}
