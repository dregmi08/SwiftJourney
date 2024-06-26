//
//  ContentView.swift
//  Memorize
//
//  Created by Drishti Regmi on 6/24/24.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        let arrayOfEmojis = ["👻", "🎃", "🕷️", "😈", "😈"]
        HStack {
            ForEach(arrayOfEmojis.indices, id: \.self) { index in
                CardView(content: arrayOfEmojis[index])
            }
        
        }
        .padding()
        .foregroundColor(Color.orange)


    }
}


struct CardView: View {
   @State var isFaceUp = true
    let content:String
    let roundedRectangle = RoundedRectangle(cornerRadius:12)
    var body: some View {
        ZStack {
            if isFaceUp {
                roundedRectangle
                    .foregroundColor(.white)
                roundedRectangle
                    .strokeBorder(lineWidth:2)
                Text(content)
                    .font(.largeTitle)
            }
            else {
                roundedRectangle
            }
        }.onTapGesture {
            isFaceUp.toggle()
            
        }
    }
}
 


#Preview {
    ContentView()
}
