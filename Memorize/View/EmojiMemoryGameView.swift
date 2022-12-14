import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @EnvironmentObject var themeStore: ThemeStore
    @Namespace private var dealingNamespace
    
    @State private var managing = false
    @State private var viewID = 0
    @State private var dealt = Set<Int>()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack(alignment: .bottom, spacing: 5) {
                    managingButton
                    Spacer()
                }
                .foregroundColor(.blue)
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            HStack {
                deckBody
                discardPile
            }
        }
        .padding()
        .sheet(isPresented: $managing, content: { ThemeManager() })
        .onChange(of: themeStore.currentThemeIndex) { _ in
                newGame()
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card){
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .id(viewID)
        .foregroundColor(themeStore.currentTheme().color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(themeStore.currentTheme().color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var discardPile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).zIndex(-9999999999)
            
            ForEach(game.cards.filter{ isMatchedCard($0) && !isFaceUpCard($0) }) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(themeStore.currentTheme().color)
    }
    
    func isMatchedCard(_ card: EmojiMemoryGame.Card) -> Bool {
        card.isMatched
    }
    
    func isFaceUpCard(_ card: EmojiMemoryGame.Card) -> Bool {
        card.isFaceUp
    }
    
    func newGame() {
        withAnimation() {
            dealt.removeAll()
        }

        game.newGame()
        viewID += 1
    }
    
    var managingButton: some View {
        Button {
            withAnimation {
                managing = true
            }
        } label: {
            Image(systemName: "chevron.backward").scaleEffect(1.5)
            Text("Memorize")
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            newGame()
        }
    }
    
    // MARK: - Deal Methods
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    // MARK: -
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    // MARK: - 
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let themeStore = ThemeStore(named: "ViewTheme")
        let game = EmojiMemoryGame(themeStore: themeStore)
        return EmojiMemoryGameView(game: game)
    }
}
