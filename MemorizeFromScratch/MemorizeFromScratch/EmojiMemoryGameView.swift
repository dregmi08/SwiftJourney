//
//  EmojiMemoryGameView.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 6/26/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    typealias Card = MemoryGame<String>.Card
    
    private let aspectRatio: CGFloat = 2/3

    var body: some View {
        
        VStack {
            Text("Memorize: \(viewModel.themeName) edition")
            
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundColor(themeColorSetter(viewModel.themeColor))
            
            Text("Score: \(viewModel.score)").animation(nil)
            
                cards
          
            HStack{
                Button(action: {
                    withAnimation {
                        viewModel.shuffle()
                    }
                })
                {
                    Image(systemName: "shuffle.circle")
                }
                .font(.largeTitle)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.newGame()
                    }
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
    

    private var cards : some View {
        
        AspectVGrid(aspectRatio: aspectRatio, viewModel.cards) { card in
            if(hasBeenDealt(card: card)) {
                CardStruct(card)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        chooseCardAnimation(card)
                    }
                    .transition(.offset(
                        x: CGFloat.random(in: -1000...1000),
                        y: CGFloat.random(in: -1000...1000)))
            }
         }
        .onAppear {
            withAnimation {
                for card in viewModel.cards {
                    dealt.insert(card.id)
                    
                }
            }
        }
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func hasBeenDealt(card : Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var unDealtCards : [Card] {
        viewModel.cards.filter {!hasBeenDealt(card: $0)}
    }
    
    private func chooseCardAnimation (_ card: Card) {
        withAnimation(.easeInOut(duration: 0.5)) {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, card.id)
        }
    }
    
    @State private var lastScoreChange = (0, "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, cardID) = lastScoreChange
        return card.id == cardID ? amount : 0
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
