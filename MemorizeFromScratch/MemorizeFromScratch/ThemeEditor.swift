//
//  ThemeEditor.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 9/17/24.
//

import SwiftUI

struct ThemeEditor: View {

    @Binding var theme : Theme
    
    var body: some View {
        Form {
            Section(header: Text("Theme Name")) {
                TextField("Give Theme a Name", text: $theme.name)
            }
            Section(header: Text("Emoji Set")) {
                TextField("Input Emoji Set", text: $theme.emojiSet)
            }
           
            Section(header: Text("Theme Color")) {ColorPicker("Choose a color", selection: Binding(
                get: { Color(rgba: theme.color) },
                    set: { newColor in
                        theme.color = RGBA(color: newColor)
                    }
                ))
            }
            Stepper("Pairs in Game: \(theme.numOfPairs)", value: $theme.numOfPairs, in: 0...theme.emojiSet.count)
        }
    }
}
