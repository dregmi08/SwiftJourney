//
//  ContentView.swift
//  Memorize
//
//  Created by Drishti Regmi on 6/24/24.
//

import SwiftUI


struct ContentView: View {
    @State var arrayOfEmojis = ["👻", "🎃", "🕷️", "😈", "💀", "👻", "🎃", "🕷️", "😈", "💀"]
    @State var emojiCount = 3
    var body: some View {
        
        VStack {
            ScrollView {
                cards
            }
            Spacer()
            cardCountAdjusters
            
        }.padding()
    }
    
    var cardCountAdjusters : some View {
        HStack {
            cardRemover
            Spacer()
            cardAdd
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    var cards : some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum:120))]) {
            ForEach(0..<emojiCount, id: \.self) { index in
                CardView(content: arrayOfEmojis[index]).aspectRatio(2/3, contentMode: .fit)
            }
        }.foregroundColor(.orange)
    }
    
    func cardCountAdjuster (by offset: Int, symbol:String) -> some View {
        Button(action: {
                emojiCount += offset
            
            
        }, label: {
            Image(systemName: symbol)
        }).disabled(emojiCount + offset < 1 || emojiCount + offset > arrayOfEmojis.count)
    }
        var cardRemover: some View {
            
            return cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
        }
        
        var cardAdd: some View {
            return cardCountAdjuster(by: 1, symbol: "rectangle.stack.badge.plus.fill")
        }
}


struct CardView: View {
   @State var isFaceUp = true
    let content:String
    let roundedRectangle = RoundedRectangle(cornerRadius:12)
    var body: some View {
        ZStack {
            Group {
                roundedRectangle
                    .foregroundColor(.white)
                roundedRectangle
                    .strokeBorder(lineWidth:2)
                Text(content)
                    .font(.largeTitle)
            }.opacity(isFaceUp ? 1:0)
            roundedRectangle.fill().opacity(isFaceUp ? 0 : 1)
        }.onTapGesture {
            isFaceUp.toggle()
            
        }
    }
}
 


#Preview {
    ContentView()
}
