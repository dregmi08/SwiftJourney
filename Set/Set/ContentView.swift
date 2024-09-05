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
                viewModel.newGame()
            }) {
            Text("New Game")
        }
    } 
    
    @State var dealSourceNamespace = true
    @State var discardedSourceNamespace = false
    
    @ViewBuilder
    var cards : some View {
        AspectVGrid(aspectRatio: aspectRatio, items: viewModel.allCards) { card in
                if(hasBeenDealt(card: card)) {
                CardStruct(card)
                    .matchedGeometryEffect(id: "\(card.id)15", in: dealingNamespace, isSource: dealSourceNamespace)
                    .matchedGeometryEffect(id: "\(card.id)10" , in: discardNamespace, isSource: discardedSourceNamespace)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewModel.selectCard(card)
                            discardCard(card)
                        }
                    }
                }
        
            }
            .onAppear() {
                    for card in viewModel.currentlyDealt {
                        dealt.insert(card.id)
                    }
            }
    }
    
    private func discardCard (_ card: Card) {
            if(viewModel.setFormed) {
                for i in (1...3) {
                    let cardToDiscard = viewModel.currentlyMatched[viewModel.currentlyMatched.count-i].id
                    dealt.remove(cardToDiscard)
                    discarded.insert(cardToDiscard)
                }
                    dealSourceNamespace.toggle()
                    discardedSourceNamespace.toggle()
        }
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func hasBeenDealt(card : Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards : [Card] {
        viewModel.allCards.filter {!hasBeenDealt(card: $0)}
    }
    
    private var dealtCards : [Card] {
        viewModel.allCards.filter {hasBeenDealt(card: $0)}
    }

    
    var deckPile : some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardStruct(card)
                    .frame(width: 66, height: 100)
                    .matchedGeometryEffect(id: "\(card.id)15", in: dealingNamespace)
            }
        }
        .onTapGesture {
            withAnimation (.easeInOut(duration: 0.5)) {
                if(!viewModel.cardDeck.isEmpty) {
                    viewModel.dealCards()
                    for i in (1...3) {
                        dealt.insert(viewModel.allCards[viewModel.currentlyDealt.count-i].id)
                    }
                }
            }
        }
    }
    
    
    @State private var discarded = Set<Card.ID>()
    
    private func hasBeenMatched(card : Card) -> Bool {
        discarded.contains(card.id)
    }
    
    private var matchedCards : [Card] {
        viewModel.allCards.filter {hasBeenMatched(card: $0)}
    }

    var discardPile : some View {
        ZStack {
            ForEach(matchedCards) { card in
                CardStruct(card)
                    .frame(width: 66, height: 100)
                    .matchedGeometryEffect(id: "\(card.id)10", in: discardNamespace)
            }
        }

    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(viewModel : SwiftViewModel())
    }
}
