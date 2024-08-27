//
//  ContentView.swift
//  Set
//
//  Created by Drishti Regmi on 8/5/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : SwiftViewModel
    var aspectRatio: CGFloat = 2/3
    var body: some View {
        VStack {
            Text("Set: A Matching Game")
                .foregroundColor(Color(red: 0.93, green: 0.5, blue: 0.6))
                .font(.custom("MarkerFelt-Wide", size: 30))
        
                cards
            
            HStack {
                Button(action: {
                    viewModel.newGame()
                }) { 
                    Text("New Game")
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.dealCards()
                   
                }) {
                    Text("Deal 3 More")
                }
                .disabled(viewModel.cards.count == 0)
            }
            .foregroundColor(Color(red: 0.93, green: 0.5, blue: 0.6))
            .font(.custom("MarkerFelt-Wide", size: 25))
            
        }
        .padding()
    
    }
    
    @ViewBuilder
    var cards : some View {
        AspectVGrid(aspectRatio: aspectRatio, items: viewModel.currentlyDealt) { card in
            CardStruct(card)
                .onTapGesture {
                    viewModel.selectCard(card)
                }
        }
    }
}



struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(viewModel : SwiftViewModel())
    }
}
