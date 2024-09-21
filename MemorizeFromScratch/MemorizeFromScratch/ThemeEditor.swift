//
//  ThemeEditor.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 9/17/24.
//

import SwiftUI

struct ThemeEditor: View {

    @Binding var theme : Theme
    @FocusState var focus: Focused?
    
    enum Focused {
        case name, emojis
    }
    
    var body: some View {
        Form {
            Section(header: Text("Theme Name")) {
                TextField("Give Theme a Name", text: $theme.name)
                    .focused($focus, equals: .name)
            }
            Section(header: Text("Emoji Set")) {
                TextField("Input Emoji Set", text: $theme.emojiSet)
                    .focused($focus, equals: .emojis)
            }
           
            Section(header: Text("Theme Color")) {ColorPicker("Choose a color", selection: Binding(
                get: { Color(rgba: theme.color) },
                    set: { newColor in
                        theme.color = RGBA(color: newColor)
                        focus = nil
                    }
                ))
                .onTapGesture {
                    focus = nil
                }
            }
            Stepper("Pairs in Game: \(theme.numOfPairs)", value: $theme.numOfPairs, in: 0...theme.emojiSet.count)
                .onTapGesture {
                    focus = nil
                }
        }
        .onAppear {
            focus = theme.name.isEmpty ? .name : theme.emojiSet.isEmpty ? .emojis : nil
        }
        .onTapGesture {
            focus = nil
        }
    }
}
