//
//  EmojiMemoryGameView.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 6/26/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    var viewModel : EmojiMemoryGame
    let emojis = ["🕷️", "🧙🏽", "🍭", "🕸️", "💀", "🎃", "☠️", "👻", "😈"]
   
    @State var numOfPairs = 9
    
    var body: some View {
        ScrollView {
            cards
        }.padding()
    }
    
    var cards : some View {
            return LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                ForEach(viewModel.cards.indices, id: \.self) { index in
                        CardStruct(emojiContent: emojis[index]).aspectRatio(2/3, contentMode: .fit)
                        CardStruct(emojiContent: emojis[index]).aspectRatio(2/3, contentMode: .fit)
                    }
                
            }
    }
}



//create the card struct
 struct CardStruct: View {
    @State var flipped = true
    
    let emojiContent: String
     
    var body: some View {
        //create rounded rectangle
        //param for emoji
       if(flipped) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                Text(" ")
            }
            .foregroundColor(.orange)
            .font(.largeTitle)
            .onTapGesture(perform: {
                flipped.toggle();
            })
        }
        else {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                .stroke()
                .foregroundColor(.orange)
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
    EmojiMemoryGameView()
}
