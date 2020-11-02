//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Kris on 30/10/2020.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "🐶🦁🐻🐥🐷🐮"
    
    @Published private var emojiArt: EmojiArt {
        didSet {
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untilted)
        }
    }
    
    private static let untilted = "EmojiArtDocument.Untilted"
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untilted)) ?? EmojiArt()
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroungImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    //MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroungImage = nil
        if let url = emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroungImage = UIImage(data: imageData)
                        } 
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location:  CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
