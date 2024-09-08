//
//  ContentView.swift
//  Set
//
//  Created by Drishti Regmi on 8/5/24.
//

import SwiftUI

struct ContentView: View {
    typealias Card = SetModel.Card
    
    @ObservedObject var viewModel : SwiftViewModel
    
    @Namespace private var dealingNamespace
    @Namespace private var discardNamespace
    
    var aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
            titleText
            cards
            deckAndDiscard
            buttonsView
        }
        .padding()
    }
    
    private var deckAndDiscard : some View {
        HStack {
            deckPile
            Spacer()
            discardPile
        }
    }
    
    private var buttonsView : some View {
            newGameButton
                .foregroundColor(Color(red: 0.93, green: 0.5, blue: 0.6))
                .font(.custom("MarkerFelt-Wide", size: 25))
    }
    
    private var titleText : some View {
        Text("Set: A Matching Game")
            .foregroundColor(Color(red: 0.93, green: 0.5, blue: 0.6))
            .font(.custom("MarkerFelt-Wide", size: 30))
    }
    
    private var newGameButton: some View {
        Button(action: {
            withAnimation() {
                newGame()
            }
            }) {
            Text("New Game")
        }
    } 
    
    private func newGame() {
        viewModel.newGame()
        isSourceNamespace = true
        dealt = Set<Card.ID>()
        for card in viewModel.displayed {
            deal(card)
        }
    }
    
    @State var dealt = Set<Card.ID>()
    @State var isSourceNamespace = true

    private func deal(_ card: Card) {
        dealt.insert(card.id)
    }
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    @ViewBuilder
    var cards : some View {
        AspectVGrid(aspectRatio: aspectRatio, items: viewModel.displayed) { card in
            if(isDealt(card)) {
                CardStruct(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: "\(card.id)0", in: discardNamespace)
                    .onTapGesture {
                        withAnimation {
                            viewModel.choose(card)
                        }
                    }
                }
            }
    }
    
    
    var deckPile : some View {
        ZStack {
            ForEach(viewModel.deck) { card in
                CardStruct(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity , removal: .scale))
            }
        }
        .frame(width: 66, height: 100)
        .onAppear {
            withAnimation {
                for card in viewModel.displayed {
                    deal(card)
                }
            }
        }
        .onTapGesture {
            withAnimation (.easeInOut(duration: 0.5)) {
                for card in viewModel.deck.prefix(3) {
                    deal(card)
                }
                viewModel.deal()
            }
        }
    }
    
    var discardPile : some View {
        ZStack {
            ForEach(viewModel.matchPile) { card in
                CardStruct(card)
                    .matchedGeometryEffect(id: "\(card.id)0", in: discardNamespace)
                    .transition(.asymmetric(insertion: .identity , removal: .scale))
            }
        }                   
        .frame(width: 66, height: 100)
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(viewModel : SwiftViewModel())
    }
}
