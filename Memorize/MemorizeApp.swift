//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Даниял on 06.09.2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var themeStore: ThemeStore
    var game: EmojiMemoryGame
    
    init() {
        themeStore = ThemeStore(named: "Theme4")
        game = EmojiMemoryGame(themeStore: themeStore)
    }
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
                .environmentObject(themeStore)
        }
    }
}
