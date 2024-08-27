//
//  EmojiMemoryGameView.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 6/26/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3

    var body: some View {
        
        VStack {
            Text("Memorize: \(viewModel.themeName) edition")
            
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundColor(themeColorSetter(viewModel.themeColor))
            
            Text("Score: \(viewModel.score)")
            
         
                cards.animation(.default, value: viewModel.cards)
          
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
    
    @ViewBuilder
    private var cards : some View {
        AspectVGrid(aspectRatio: aspectRatio, viewModel.cards) { card in
                    CardStruct(card)
                        .onTapGesture {
                            self.viewModel.choose(card)
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

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
