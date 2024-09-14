//
//  ThemeManager.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 9/13/24.
//

import SwiftUI

struct ThemeManager: View {
    
    @State var selectedStore: EmojiThemesStore?
    let stores : [EmojiThemesStore]
    
    var body: some View {
        NavigationSplitView  {
            List(stores, selection: $selectedStore) { store in
                Text(store.themeName)
                    .tag(store)
            }
        } content : {
            if let selectedStore {
                EditableThemeList(store: selectedStore)
            }
            Text("Choose a store")
        }
        detail : {
            Text("Choose a theme")
        }
    }
}

//#Preview {
//    ThemeManager()
//}
