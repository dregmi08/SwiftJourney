//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 8/29/24.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            autosave()
            if emojiArt.background != oldValue.background {
                Task {
                    await fetchBackgroundImage()
                }
            }
        }
    }
    
    private let autosaveURL : URL = URL.documentsDirectory.appendingPathComponent("Autosaved.emojiArt")
    
    private func autosave() {
        save(to: autosaveURL)
        print("\(autosaveURL)")
    }
    
    private func save(to url: URL) {
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        }
        catch let error {
            print("EmojiArtDocument: error while saving \(error.localizedDescription)")
        }
    }
    
    init () {
        if let data = try? Data(contentsOf: autosaveURL),
           let autosavedEmojiArt = try? EmojiArt(json: data){
            emojiArt = autosavedEmojiArt
        }
    }
    
    var emojis : [Emoji] {
        emojiArt.emojis
    }
    
//    var background: URL? {
//        emojiArt.background
//    }
    
    @Published var background: Background = .none
    
    //MARK: - Background
    
    @MainActor
    private func fetchBackgroundImage() async {
        if let url = emojiArt.background {
            background = .fetching(url)
            do {
                let image = try await fetchUIImage(url: url)
                if (url == emojiArt.background) {
                    background = .found(image)
                }
            }
            catch {
                background = .failed("could not find image")
            }
        }
        else {
            background = .none
        }
    }
    
    private func fetchUIImage(url: URL) async throws  -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let image =  UIImage(data: data) {
            return image
        }
        else {
            throw FetchError.invalidImageData("image dragged into frame is invalid")
        }
        
    }
    
    enum FetchError: Error {
        case invalidImageData(String)
    }
     
    enum Background {
        case none
        case fetching(URL)
        case found(UIImage)
        case failed(String)
        
        var uiImage: UIImage? {
            switch self {
            case .found(let uiImage): return uiImage
            default: return nil
            }
        }
        
        var urlBeingFetched: URL? {
            switch self {
            case .fetching(let url): return url
            default: return nil
            }
        }
        
        var isFetching: Bool { urlBeingFetched != nil }
        
        var failureReason: String? {
            switch self {
            case .failed(let reason): return reason
            default: return nil
            }
        }
    }
    
    //MARK: - Intents

    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
     func addEmoji(position: CGPoint, size: CGFloat, _ emoji : String){
        emojiArt.addEmoji(position: position, size: Int(size), emoji)
    }
    
    //get the geometry reader and get the offset to add by, take in emoji
    func moveEmoji(offset: CGOffset, id: Emoji.ID) {
        emojiArt.moveEmoji(offset: offset, id: id)
    }
    
    func resizeEmoji( _ pinchScale: CGFloat, _ id: Emoji.ID) {
        emojiArt.resizeEmoji(pinchScale, id)
    }
}
