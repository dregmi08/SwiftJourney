//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Drishti Regmi on 6/24/24.
//

import SwiftUI


struct EmojiMemoryGameView: View {
   @ObservedObject var viewModel: EmojiMemoryGame
    let arrayOfEmojis = ["👻", "🎃", "🕷️", "😈", "💀", "👻", "🎃", "🕷️", "😈", "💀"]

    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }.padding()
    }
    
  
    
    var cards : some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum:90), spacing: 0)], spacing:0) {
            ForEach(viewModel.cards.indices, id: \.self) { index in
                CardView(viewModel.cards[index]).aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
        }.foregroundColor(.orange)
    }
    

}


struct CardView: View {
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    let card: MemoryGame<String>.Card
    let roundedRectangle = RoundedRectangle(cornerRadius:12)
    var body: some View {
        ZStack {
            Group {
                roundedRectangle
                    .foregroundColor(.white)
                roundedRectangle
                    .strokeBorder(lineWidth:2)
                Text(card.content)
                    .font(.system(size:200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }.opacity(card.isFaceUp ? 1:0)
            roundedRectangle.fill().opacity(card.isFaceUp ? 0 : 1)
        }
    }
}
 


/*#Preview {
    EmojiMemoryGameView()
}*/

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
