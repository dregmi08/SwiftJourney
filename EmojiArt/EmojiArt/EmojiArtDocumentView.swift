//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 8/29/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document = EmojiArtDocument()

    typealias emoji = EmojiArt.Emoji
    
    private let emojiSize: CGFloat = 40
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            ThemesView()
                .font(.system(size: emojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody : some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                doccontent(in: geometry)
                    .scaleEffect(zoomamt * currentZoom)
                    .offset(pan + gestPanAmt)
            }
            .gesture(dragGest .simultaneously(with: zoom))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
    @State private var zoomamt: CGFloat = 0.5
    @State private var pan: CGOffset = .init(width: 100, height: 100)

    @ViewBuilder
    private func doccontent(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background) { phase in
            if let image = phase.image {
                image
            } else if let url = document.background {
                if phase.error != nil {
                    Text("\(url)")
                }
                else {
                    ProgressView()
                }
            }
        }
        .position(emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
    }
    
    private func drop(_ sturldatas : [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(position: emojiPosition(location, geometry), size: emojiSize, emoji)
                return true
            default:
                break
            }
        }
        return false
    }
    
    @GestureState private var currentZoom: CGFloat = 1
    
    private var zoom : some Gesture {
        MagnificationGesture()
            .updating($currentZoom) {pinchamt, currentZoom, _ in
                currentZoom *= pinchamt
            }
            .onEnded { pinchScale in
                zoomamt *= pinchScale
            }
    }
    
    @GestureState private var gestPanAmt : CGOffset = .zero
    
    private var dragGest : some Gesture {
        DragGesture()
            .updating($gestPanAmt) { value, gestPanAmt, _ in
                gestPanAmt = value.translation
            }
            .onEnded { value in
                pan += value.translation
            }
    }
    
    private func emojiPosition (_ location: CGPoint, _ geometry: GeometryProxy) -> emoji.Position {
        let center = geometry.frame(in: .local).center
        return emoji.Position(
            x: Int((location.x - center.x - pan.width)/zoomamt),
            y: Int(-(location.y - center.y - pan.height)/zoomamt)
        )
    }
}


struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
            .environmentObject(EmojiThemesStore(themeName: "preview"))
    }
}
