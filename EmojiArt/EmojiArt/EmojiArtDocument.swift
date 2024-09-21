//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Drishti Regmi on 8/29/24.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let emojiart = UTType(importedAs: "edu.ucsd.emojiart")
}

class EmojiArtDocument: ObservableObject, ReferenceFileDocument {
    func snapshot(contentType: UTType) throws -> Data {
        try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
    static var readableContentTypes: [UTType] {
        [.emojiart]
    }
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArt(json: data)
        }
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            if emojiArt.background != oldValue.background {
                Task {
                    await fetchBackgroundImage()
                }
            }
        }
    }
    
    
    
    init () {
        
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
    
    func setBackground(_ url: URL?, undoWith undoManager: UndoManager? = nil) {
        performUndo(operation: "Set the Background", with: undoManager) {
            emojiArt.background = url
        }
    }
    
    func addEmoji(position: CGPoint, size: CGFloat, _ emoji : String, undoWith undoManager: UndoManager? = nil){
        performUndo(operation: "Add Emoji", with: undoManager) {
            emojiArt.addEmoji(position: position, size: Int(size), emoji)
        }
    }
    
    //get the geometry reader and get the offset to add by, take in emoji
    func moveEmoji(offset: CGOffset, id: Emoji.ID, undoWith undoManager: UndoManager? = nil) {
        performUndo(operation: "Move Emoji", with: undoManager) {
            emojiArt.moveEmoji(offset: offset, id: id)
        }
    }
    
    func resizeEmoji( _ pinchScale: CGFloat, _ id: Emoji.ID, undoWith undoManager: UndoManager? = nil) {
        performUndo(operation: "Resize Emoji", with: undoManager) {
            emojiArt.resizeEmoji(pinchScale, id)
        }
    }
    
    private func performUndo(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
            let oldEmojiArt = emojiArt
            doit()
            undoManager?.registerUndo(withTarget: self) { myself in
                myself.performUndo(operation: operation, with: undoManager) {
                    myself.emojiArt = oldEmojiArt
                }
            }
            undoManager?.setActionName(operation)
        }
}
