//
//  ThemeManager.swift
//  Memorize
//
//  Created by Даниял on 28.09.2022.
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var themeStore: ThemeStore
    @Environment(\.presentationMode) var presentationMode
    @State private var editMode: EditMode = .inactive
    @State private var selectedTheme: Theme?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.themes) { theme in
                    NavigationLink(destination: ThemeEditor(theme: $themeStore.themes[theme])) {
                        HStack {
                            Image(systemName: "rectangle.portrait.fill")
                                .font(.largeTitle)
                                .foregroundColor(theme.color)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(theme.named)
                                    Spacer()
                                    Text(String(theme.countCard))
                                }
                                .padding(2)
                                Text(theme.contents)
                            }
                        }
                    }
                    .gesture(editMode == .inactive ?
                             setCurrentThemeGesture(index: themeStore.themes.index(matching: theme) ?? 0) : nil)
                }
                .onDelete() { indexSet in
                    themeStore.themes.remove(atOffsets: indexSet)
                }
                .onMove() { indexSet, newOffset in
                    themeStore.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
                .sheet(item: $selectedTheme)
                {
                    themeStore.checkErrors()
                } content: { theme in
                    ThemeEditor(theme: $themeStore.themes[theme])
                }
            }
            .navigationTitle("Manage Themes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        themeStore.insertTheme(named: "New", color: Color.red.toRGBAColor, countCard: 6, contents: String())
                        selectedTheme = themeStore.themes.last
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    func setCurrentThemeGesture(index: Int) -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                themeStore.setCurrentTheme(index: index)
                presentationMode.wrappedValue.dismiss()
        }
    }
}
