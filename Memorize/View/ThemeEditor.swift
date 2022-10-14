//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Даниял on 28.09.2022.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    @State private var emojisToAdd = ""
    
    var body: some View {
        Form {
            nameSection
            emojiSection
            cardCountSection
            colorSection
        }
        .navigationTitle(theme.named)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var nameSection: some View {
        Section(header: Text("THEME NAME")) {
            TextField("Name", text: $theme.named)
        }
    }
    
    var emojiSection: some View {
        Section(header: Text("Emojis")) {
            let emojis = theme.contents.removingDuplicateCharacters.map { String($0) }
            
            TextField("Add Emoji", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.contents.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
        }
    }
    
    var cardCountSection: some View {
        Section(header: Text("CARD COUNT")) {
            let maxPairs = theme.contents.count > 1 ? theme.contents.count : 2
            Stepper("\(theme.countCard) Pairs", value: $theme.countCard, in: 2...maxPairs)
        }
    }
    
    var colorSection: some View {
        Section(header: Text("COLOR")) {
            ColorPicker(selection: $theme.color) {
                Image(systemName: "rectangle.portrait.fill")
                    .font(.title)
                    .foregroundColor(theme.color)
            }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation() {
            theme.contents = (theme.contents + emojis)
                .filter{ $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
}
