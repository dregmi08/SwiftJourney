//
//  AspectVGrid.swift
//  Set
//
//  Created by Drishti Regmi on 8/16/24.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View> : View {
  
    let aspectRatio: CGFloat
    var items : [Item]
    var content: (Item) -> ItemView
    
    init(aspectRatio: CGFloat, items: [Item], @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.aspectRatio = aspectRatio
        self.items = items
        self.content = content
    }
   
    var body: some View {
        GeometryReader { geometry in
           // let cardWidth = cardWidthPicker(cardCount: CGFloat(items.count), size: geometry.size, aspectRatio: aspectRatio)
            LazyVGrid (columns: [GridItem(.adaptive(minimum: 70), spacing: 0)], spacing: 0){
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                        .padding(4)
                }
            }
        }
    }
    
    /*func cardWidthPicker (cardCount: CGFloat, size: CGSize,  aspectRatio: CGFloat) -> CGFloat {

        var columnCount = 2.0
        repeat {
            let width = size.width / columnCount
            let height = width/aspectRatio
            let rowCount = (cardCount/columnCount).rounded(.up)
            
            if height * rowCount < size.height {
                return (size.width/columnCount).rounded(.down)
            }
            columnCount += 1.0
            
        } while columnCount < cardCount 
        return min(size.width/cardCount, size.height * aspectRatio).rounded(.down)
    }*/
}
