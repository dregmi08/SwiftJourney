//
//  ContentView.swift
//  Memorize
//
//  Created by Drishti Regmi on 6/24/24.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        HStack {
            CardView(isFaceUp: true)
            CardView()
            CardView(isFaceUp: true)
        }
        .padding()
        .foregroundColor(Color.orange)


    }
}


struct CardView: View {
   @State var isFaceUp = false
    let roundedRectangle = Circle()
    var body: some View {
        ZStack {
            if isFaceUp {
                roundedRectangle
                    .foregroundColor(.white)
                roundedRectangle
                    .strokeBorder(lineWidth:2)
                Text("🐝")
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
