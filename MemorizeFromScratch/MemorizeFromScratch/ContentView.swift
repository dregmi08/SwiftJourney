//
//  ContentView.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 6/26/24.
//

import SwiftUI

struct ContentView: View {
    
    let halloween = ["🕷️", "🧙🏽", "🍭", "🕸️", "💀", "🎃", "☠️", "👻", "😈", "🫣", "🕷️", "🧙🏽", "🍭", "🕸️", "💀", "🎃", "☠️", "👻", "😈", "🫣"]
    let food = ["🍔", "🌭", "🍗", "🧁", "🎂", "🥨", "🍣", "🧇", "🍔", "🌭", "🍗", "🧁", "🎂", "🥨", "🍣", "🧇"]
    let flags = ["🇺🇸", "🇳🇵", "🇬🇷", "🇰🇷", "🇬🇧", "🇮🇳", "🇯🇵", "🇮🇹", "🇧🇷", "🇨🇦", "🇹🇭", "🇼🇸", "🇺🇸", "🇳🇵", "🇬🇷", "🇰🇷", "🇬🇧", "🇮🇳", "🇯🇵", "🇮🇹", "🇧🇷", "🇨🇦", "🇹🇭", "🇼🇸"]
    @State var theme = 1
    @State var numCardsDisplayed = 20
    
    var body: some View {
        
        Text("Memorize!").font(.largeTitle)
        ScrollView {
            cards
        }.padding()
        themeButtons
       
        
    }
    
    var cards : some View {
        @State var themeArray:[String]
        switch theme {
        case 1:
            themeArray = halloween.shuffled()
        case 2:
            themeArray = food.shuffled()
        case 3:
            themeArray = flags.shuffled()
        default:
            themeArray = ["No theme matched"] // Default value if none of the cases match
        }
            return LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(0..<numCardsDisplayed, id: \.self) { index in
                        CardStruct(themeCol: theme, emojiContent: themeArray[index]).aspectRatio(2/3, contentMode: .fit)
                    }
                
            }
        
    }
    
    var halloweenTheme : some View {
        VStack {
            Image(systemName: "theatermasks")
                .font(.largeTitle)
            Button (action: {
                theme = 1
                numCardsDisplayed = 20
            }) {
                Text("Halloween")
            }
                .font(.custom("Verdana", size: 16))
        }
        .foregroundColor(.orange)
    }
    
    var foodTheme : some View {
        VStack {
            Image(systemName: "fork.knife")
            .font(.largeTitle)
            Button(action: {
                theme = 2
                numCardsDisplayed = 16
            }) {
                Text("Food")
            }
            .font(.custom("Verdana", size: 16))
        }
        .foregroundColor(.red)
    }
    
    var flagTheme : some View {
        VStack {
            Image(systemName: "flag.fill")
            .font(.largeTitle)
            Button (action: {
                theme = 3
                numCardsDisplayed = 24
            }) {
                Text("Flag")
            }
            .font(.custom("Verdana", size: 16))
        }
        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
    
    var themeButtons : some View {
        HStack {
            halloweenTheme
            Spacer()
            foodTheme
            Spacer()
            flagTheme
        }
        .padding()
    }
    
}

func getColor(for themeCol: Int) -> Color {
    switch themeCol {
    case 1:
        return Color.orange
    case 2:
        return Color.red
    case 3:
        return Color.blue
    default:
        return Color.blue
    }
}

//create the card struct
 struct CardStruct: View {
    @State var flipped = true
     var themeCol : Int
    
    let emojiContent: String
     
    var body: some View {
        //create rounded rectangle
        //param for emoji
       if(flipped) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                Text(" ")
            }
            .foregroundColor(getColor(for: themeCol))
            .font(.largeTitle)
            .onTapGesture(perform: {
                flipped.toggle();
            })
        }
        else {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                .stroke()
                .foregroundColor(getColor(for: themeCol))
                Text(emojiContent)
            }
            .font(.largeTitle)
            .onTapGesture(perform: {
                flipped.toggle();
            })
        }
        
    }
}

#Preview {
    ContentView()
}
