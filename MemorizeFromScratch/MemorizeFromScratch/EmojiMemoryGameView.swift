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
                .foregroundColor(Color(rgba: viewModel.theme.color))
            
            Text("Score: \(viewModel.score)").animation(nil)
            
                cards
          
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.shuffle()
                    }
                }) {
                    Image(systemName: "shuffle.circle")
                }
                .font(.largeTitle)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.newGame()
                    }
                }) {
                    Text("New Game")
                }
            }
        }
        .padding()
        .foregroundColor(Color(rgba: viewModel.theme.color))
        .font(.system(size: 20, weight: .bold, design: .rounded))
    }
    

    private var cards : some View {
        AspectVGrid(aspectRatio: aspectRatio, viewModel.cards) { card in
            CardStruct(card)
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                .onTapGesture {
                    chooseCardAnimation(card)
                }
         }
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

extension RGBA {
     init(color: Color) {
         var red: CGFloat = 0
         var green: CGFloat = 0
         var blue: CGFloat = 0
         var alpha: CGFloat = 0
         UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
         self.init(red: Double(red * 255), green: Double(green * 255), blue: Double(blue * 255), alpha: Double(alpha))
     }
}

extension Color {
     init(rgba: RGBA) {
         self.init(.sRGB, red: rgba.red/255, green: rgba.green/255, blue: rgba.blue/255, opacity: rgba.alpha)
     }
}
