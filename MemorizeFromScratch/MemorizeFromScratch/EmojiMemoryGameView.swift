//
//  EmojiMemoryGameView.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 6/26/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    

    var body: some View {
        
        VStack {
            Text("Memorize: " + viewModel.themeName + " edition")
            
            .font(.system(size: 25, weight: .bold, design: .rounded))
            .foregroundColor(themeColorSetter(viewModel.themeColor))
            
            Text("Score: \(viewModel.score)")
            
            ScrollView {
                cards
            }
            HStack{
                Button(action: {
                    viewModel.shuffle()
                })
                {
                    Image(systemName: "shuffle.circle")
                }
                .font(.largeTitle)
                
                Spacer()
                
                Button(action: {
                    viewModel.newGame()
                })
                {
                    Text("New Game")
                }
            }
        }
        .padding()
        .foregroundColor(themeColorSetter(viewModel.themeColor))
        .font(.system(size: 20, weight: .bold, design: .rounded))
    }

  
    var cards : some View {
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing:0)], spacing:0) {
            ForEach(viewModel.cards.indices) { index in
                    CardStruct(viewModel.cards[index])
                        .aspectRatio(2/3, contentMode: .fill)
                        .padding(4)
                        .onTapGesture {
                            self.viewModel.choose(viewModel.cards[index])
                        }
                }
        }
    }
        
}


func themeColorSetter(_ themeCol: String) -> Color {
     switch themeCol {
     case "orange":
         return Color.orange
     case "green":
         return Color.green
     case "purple":
         return Color.purple
     case "red":
         return Color.red
     case "grey":
         return Color.gray
     case "brown":
         return Color.brown
     default:
         return Color.orange
     }
 }

//create the card struct
 struct CardStruct: View {
     let card : MemoryGame<String>.Card
    
     init(_ card: MemoryGame<String>.Card) {
         self.card = card
     }
     
    var body: some View {
        //create rounded rectangle
        //param for emoji
        if(card.isFaceUp) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                .stroke()
                .foregroundColor(themeColorSetter(card.cardColor))
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
        else {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                Text(" ")
            }
            .foregroundColor(themeColorSetter(card.cardColor))
            .font(.largeTitle)
            
        }
    }
}


struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
