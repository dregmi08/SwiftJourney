//
//  EmojiThemesStore.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 9/8/24.
//

import SwiftUI

extension UserDefaults {
    func themes(forKey key : String) -> [EmojiThemes] {
        if let jsonData = data(forKey: key),
             let decodedPalettes = try? JSONDecoder().decode([EmojiThemes].self, from: jsonData) {
                 return decodedPalettes
        }
        else {
            return []
        }
    }
    func set(_ themes: [EmojiThemes], forKey key : String) {
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
}

extension EmojiThemesStore : Hashable {
    static func == (lhs: EmojiThemesStore, rhs: EmojiThemesStore) -> Bool {
        lhs.themeName == rhs.themeName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(themeName)
    }
}

class EmojiThemesStore: ObservableObject, Identifiable {
    let themeName: String
    
    var id : String {themeName}
    
    private var userDefaultsKey : String {"EmojiThemesStore" + themeName}

    var themes : [EmojiThemes] {
        get {
            UserDefaults.standard.themes(forKey: themeName)
        }
        set {
            if(!newValue.isEmpty){
                UserDefaults.standard.set(newValue, forKey: themeName)
                objectWillChange.send()
            }
        }
            
    }
    
    init(themeName: String) {
        self.themeName = themeName
        
        if themes.isEmpty {
            self.themes = EmojiThemes.inbuilt
            if themes.isEmpty {
                themes = [EmojiThemes(themeName: "warning", emojis: "⁉️")]
            }
        }
    }
    
    @Published var _cursorIdx: Int = 0
    
    var correctedCursorIdx: Int {
        get {boundsChecked(_cursorIdx)}
        set {_cursorIdx = boundsChecked(newValue)}
    }
    
    private func boundsChecked (_ index : Int) -> Int {
        var idx = index % themes.count
        if(idx < 0) {
            idx += themes.count
        }
        return idx
    }
    
    func insert(_ theme: EmojiThemes, at insertionIndex: Int? = nil) { // "at" default is cursorIndex
        let insertionIndex = boundsChecked(insertionIndex ?? correctedCursorIdx)
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            themes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            themes.replaceSubrange(insertionIndex...insertionIndex, with: [theme])
        } else {
            themes.insert(theme, at: insertionIndex)
        }
    }
    
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(EmojiThemes(themeName: name, emojis: emojis), at: index)
    }
    
    func append(_ theme: EmojiThemes) { // at end of palettes
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            if themes.count == 1 {
                themes = [theme]
            } else {
                themes.remove(at: index)
                themes.append(theme)
            }
        } else {
            themes.append(theme)
        }
    }
    
    func append(name: String, emojis: String) {
        append(EmojiThemes(themeName: name, emojis: emojis))
    }
}
