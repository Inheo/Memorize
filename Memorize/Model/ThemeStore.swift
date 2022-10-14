//
//  ThemeStore.swift
//  Memorize
//
//  Created by Даниял on 27.09.2022.
//

import Foundation

struct Theme : Codable, Identifiable, Hashable
{
    var named: String
    var rgbaColor: RGBAColor
    var contents: String
    var countCard: Int
    let id: Int
    
    fileprivate init(named: String, color: RGBAColor, contents: String, countCard: Int, id: Int) {
        self.named = named
        self.rgbaColor = color
        self.contents = contents
        self.countCard = countCard
        self.id = id
    }
}

class ThemeStore: ObservableObject {
    let name: String
    @Published private(set) var currentThemeIndex = 0;
        
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "ThemeStore:" + name
    }
        
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
        
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedPalettes = try? JSONDecoder().decode(Array<Theme>.self, from: jsonData) {
            themes = decodedPalettes
        }
    }
        
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            insertTheme(named: "Vehicles",
                          color: RGBAColor(color: .blue),
                          countCard: 6,
                          contents: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜")
            insertTheme(named: "Sports",
                          color: RGBAColor(color: .red),
                          countCard: 6,
                          contents: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳")
            insertTheme(named: "Music",
                          color: RGBAColor(color: .red),
                          countCard: 4,
                          contents: "🎼🎤🎹🪘🥁🎺🪗🪕🎻")
            insertTheme(named: "Animals",
                          color: RGBAColor(color: .green),
                          countCard: 12,
                          contents: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔")
            insertTheme(named: "Animal Faces",
                          color: RGBAColor(color: .brown),
                          countCard: 8,
                          contents: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲")
            insertTheme(named: "Flora",
                          color: RGBAColor(color: .green),
                          countCard: 7,
                          contents: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻")
            insertTheme(named: "Weather",
                          color: RGBAColor(color: .cyan),
                          countCard: 8,
                          contents: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪")
            insertTheme(named: "COVID",
                          color: RGBAColor(color: .gray),
                          countCard: 5,
                          contents: "💉🦠😷🤧🤒")
            insertTheme(named: "Faces",
                          color: RGBAColor(color: .yellow),
                          countCard: 16,
                          contents: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧")
        }
    }
        
    // MARK: - Intent

    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    func currentTheme() -> Theme {
        return theme(at: currentThemeIndex)
    }
    
    func setCurrentTheme(index: Int) {
        currentThemeIndex = min(max(index, 0), themes.count - 1)
    }

    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }

    func insertTheme(named: String,
                     color: RGBAColor,
                     countCard: Int,
                     contents: String) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(named: named, color: color, contents: contents, countCard: countCard, id: unique)
        themes.append(theme)
    }
    
    func checkErrors() {
        themes = themes.filter{ !$0.named.isEmpty && $0.contents.count > 1 }
        for index in themes.indices {
            if themes[index].countCard > themes[index].contents.count {
                themes[index].countCard = themes[index].contents.count
            }
        }
    }
}
