//
//  ThemeStore.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 9/14/24.
//

import SwiftUI

extension UserDefaults {
    func themes (for key: String) -> [Theme] {
        if let themesArray = data(forKey: key),
            let themes = try? JSONDecoder().decode([Theme].self, from: themesArray) {
                return themes
        } else {
            return []
        }
    }
    
    func set(themes : [Theme], for key : String) {
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
}

class ThemeStore : ObservableObject, Identifiable {
    
    //name of the "theme store", or collection of themes
    let name : String
    
    //id for the theme store, just the theme name for now
    var id: String {name}
    
    //computed var themes, gets the themes from JSON file/User defaults getter defined above
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(for: name)
        }
        set {
            //if the new value is different from the old value of themes, then set
            //the themes array to new value and send changes
            if !newValue.isEmpty {
                UserDefaults.standard.set(themes: newValue, for: name)
                objectWillChange.send()
            }
        }
    }
   
    
    //init for theme store
    init(name: String) {
        //name is equal to the name passed to store upon its creation
        self.name = name
        
        if (themes.isEmpty) {
            //if the themes array is empty, make the array equal to inbuilt values
            themes = Theme.inbuiltThemes
            if(themes.isEmpty) {
                //if still empty, present warning
                themes = [Theme(name: "warning", color: RGBA(red: 75, green: 0, blue: 75, alpha: 1.0), emojiSet: "⁉️", numOfPairs: 1,
                                id: UUID())]
            }
        }
    }
    
    
     func addTheme(theme: Theme) {
        if let themeIdx = themes.firstIndex(where: {$0.id ==  theme.id}) {
            themes[themeIdx] = theme
        } else {
            themes.append(theme)
        }
    }
    
    func addTheme (themeName: String, emojis: String, color: RGBA) {
        addTheme(theme: Theme(name: themeName, color: color, emojiSet: emojis, id: UUID()))
    }
}
