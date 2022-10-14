//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Даниял on 09.09.2022.
//

import Foundation
import SwiftUI

class EmojiMemoryGame : ObservableObject
{
    typealias Card = MemoryGame.Card
    var themeStore: ThemeStore
    
    @Published private var model: MemoryGame!
    
    init(themeStore: ThemeStore)
    {
        self.themeStore = themeStore
        newGame()
    }
    
    private func createMemoryGame() -> MemoryGame
    {
        let theme = themeStore.currentTheme()
        let emojis = theme.contents.shuffled()
        
        return MemoryGame(numberOfPairsOfCards: theme.countCard) { pairIndex in
            return String(emojis[emojis.index(emojis.startIndex, offsetBy: pairIndex)])
        }
    }
    
    var cards: Array<MemoryGame.Card>
    {
        model.cards
    }
    
    var score: Int
    {
        model.score
    }
    
    //MARK: - Intent(s)
    
    func choose(_ card: MemoryGame.Card)
    {
        model.choose(card)
    }
    
    func shuffle()
    {
        model.shuffle()
    }
    
    func newGame()
    {
        model = createMemoryGame()
    }
}
