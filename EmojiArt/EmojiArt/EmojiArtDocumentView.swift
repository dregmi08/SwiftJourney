//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 8/29/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document = EmojiArtDocument()
    @State var emojiSelected =  Set<Emoji.ID>()

    typealias Emoji = EmojiArt.Emoji
    
    private let emojiSize: CGFloat = 40
    var body: some View {
        VStack(spacing: 0) {
            documentBody
                .onTapGesture {
                    emojiSelected = Set<Emoji.ID>()
                }
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
            .gesture(dragGest .simultaneously(with: emojiSelected.isEmpty ? zoom : nil ) .simultaneously(with: pinchEmoji()))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
    @State private var zoomamt: CGFloat = 1.0
    @State private var pan: CGOffset = .init(width: 0, height: 0)
    @State private var emojiPan: CGOffset = .init(width: 0, height: 0)


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
        .position(CGPoint(x: 0, y: 0).in(geometry))
        
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(.system(size: CGFloat(emoji.size)))
                .border(emojiSelected.contains(emoji.id) ? Color.blue : Color.clear)
                .scaleEffect(emojiSelected.contains(emoji.id) ? emojiPinchState * zoomamt : zoomamt)
                .position(emojiDragPosition(emoji: emoji, geometry: geometry))
                .gesture(selectEmoji(emoji: emoji) .simultaneously(with: dragGestEmoji(id: emoji.id) .simultaneously(with: pinchEmoji())))
        }
    }
    
    private func emojiDragPosition(emoji: Emoji, geometry: GeometryProxy) -> CGPoint {
        if(emojiSelected.contains(emoji.id)) {
            return CGPoint(
                x: emoji.position.x + emojiPanAmt.width,
                y: emoji.position.y + emojiPanAmt.height
            )
        } else {
            return emoji.position
        }
    }

    private func selectEmoji(emoji: Emoji) -> some Gesture {
        TapGesture()
            .onEnded { value in
                if(emojiSelected.contains(emoji.id)) {
                    if let removeIdx = emojiSelected.firstIndex(where: {emoji.id == $0}) {
                        emojiSelected.remove(at: removeIdx)
                    }
                } else {
                    emojiSelected.insert(emoji.id)
                }
            }
    }
    
    @State private var emojiPinch: CGFloat = 1
    @GestureState private var emojiPinchState: CGFloat = 1
    
    private func pinchEmoji() -> some Gesture {
        MagnificationGesture()
            .updating($emojiPinchState) { pinchState, emojiPinchState, _ in
                emojiPinchState = pinchState
            }
            .onEnded { finalPinchAmt in
                for id in emojiSelected {
                    document.resizeEmoji(finalPinchAmt, id)
                }
            }
    }
    
    @GestureState private var currentZoom: CGFloat = 1
    
    private var zoom : some Gesture {
        MagnificationGesture()
            .updating($currentZoom) { pinchamt, currentZoom, _ in
                currentZoom = pinchamt
            } .onEnded { pinchScale in
                zoomamt *= pinchScale
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
       
    @GestureState private var gestPanAmt : CGOffset = .zero
    @GestureState private var emojiPanAmt : CGOffset = .zero
    
    private var dragGest: some Gesture {
        DragGesture()
            .updating($gestPanAmt) { value, gestPanAmt, _ in
                gestPanAmt = value.translation
            }
            .onEnded { value in
                pan += value.translation
            }
    }
    
    private func dragGestEmoji(id: Emoji.ID) -> some Gesture {
        DragGesture()
            .updating($emojiPanAmt) { value, emojiPanAmt, _ in
                emojiPanAmt = value.translation
            }
            .onEnded { value in
                for id in emojiSelected {
                    emojiPan = value.translation
                    document.moveEmoji(offset: emojiPan, id: id)
                }
            }
    }
    
    //converts to emoji coordinates on zoomed in/out screen
    private func emojiPosition(_ location: CGPoint, _ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint (
            x: Int((location.x - center.x - pan.width)/zoomamt),
            y: Int((-(location.y - center.y - pan.height)/zoomamt))
        )
    }
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
            .environmentObject(EmojiThemesStore(themeName: "preview"))
    }
}