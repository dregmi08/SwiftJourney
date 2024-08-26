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
                .foregroundColor(.red)
                .font(.custom("MarkerFelt-Wide", size: 30))
            
            ScrollView {
                cards
            }
            
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
                .disabled(viewModel.currentlyDealt.count == 81)
            }
            .foregroundColor(.red)
            .font(.custom("MarkerFelt-Wide", size: 25))
            
        }
        .padding()
    
    }
    
    @ViewBuilder
    var cards : some View {
        AspectVGrid(aspectRatio: aspectRatio, items: viewModel.currentlyDealt) { card in
            CardStruct(card)
                .onTapGesture {
                    if(card.isMatched) {
                        viewModel.deselect(card)
                    }
                    else {
                        viewModel.selectCard(card)

                    }
                }
        }
    }
}



struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(viewModel : SwiftViewModel())
    }
}
