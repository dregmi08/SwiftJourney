//
//  Cardify.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 8/4/24.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    
    init(isFaceUp : Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
  
   
    var rotation: Double
    
    var animatableData: Double {
        get {return rotation}
        set {rotation = newValue}
    }
    
    func body(content: Content) -> some View {
        
        let roundedRectangle = RoundedRectangle(cornerRadius:12)
      
             ZStack {
                Group {
                    roundedRectangle
                        .foregroundColor(.white)
                    roundedRectangle
                        .strokeBorder(lineWidth:2)
                }.opacity(isFaceUp ? 1:0)
                .overlay(content)
                roundedRectangle.fill().opacity(isFaceUp ? 0 : 1)
             }
             .rotation3DEffect(.degrees(rotation), axis : (0,1,0))
        
             
        
        
    }
}

extension View {
    func cardify(isFaceUp: Bool, isMatched: Bool, cardColor: String) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
