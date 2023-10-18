//
//  HomeViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    
    @Published var recentNotes: [NoteFile] = [.dummy, .dummy2, .dummy3, .dummy4]
    @Published var folders: [Folder] = [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6]
    
    @Published var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
    @AppStorage("current_theme") var currentTheme: String = ThemeColor.purple.rawValue
    
    @Published var isShowSheet = false
    
    func countNotes(from folder: Folder) -> Int {
        folder.notes.count
    }
    
    func description(from notes: [any Note]) -> String {
        var description = ""
        description = notes.compactMap({ note in
            if let note = note as? NoteTextContent {
                note.text
            } else {
                ""
            }
        }).joined(separator: " ")
        
        return description
    }
    
    func bgColor(from color: String) -> Color {
        switch color {
        case ThemeColor.blue.rawValue:
            return .blue3
        case ThemeColor.green.rawValue:
            return .green3
        case ThemeColor.orange.rawValue:
            return .orange3
        case ThemeColor.pink.rawValue:
            return .pink3
        case ThemeColor.purple.rawValue:
            return .purple3
        case ThemeColor.red.rawValue:
            return .red3
        default:
            return .gray2
        }
    }
    
    func secondaryColor(from color: String) -> Color {
        switch color {
        case ThemeColor.blue.rawValue:
            return .blue2
        case ThemeColor.green.rawValue:
            return .green2
        case ThemeColor.orange.rawValue:
            return .orange2
        case ThemeColor.pink.rawValue:
            return .pink2
        case ThemeColor.purple.rawValue:
            return .purple2
        case ThemeColor.red.rawValue:
            return .red2
        default:
            return .gray2
        }
    }
    
    func accentColor(from color: String) -> Color {
        switch color {
        case ThemeColor.blue.rawValue:
            return .blue1
        case ThemeColor.green.rawValue:
            return .green1
        case ThemeColor.orange.rawValue:
            return .orange1
        case ThemeColor.pink.rawValue:
            return .pink1
        case ThemeColor.purple.rawValue:
            return .purple1
        case ThemeColor.red.rawValue:
            return .red1
        default:
            return .gray2
        }
    }
    
    func appIcon(from color: String) -> Image {
        switch color {
        case ThemeColor.blue.rawValue:
            return .logoBlue
        case ThemeColor.green.rawValue:
            return .logoGreen
        case ThemeColor.orange.rawValue:
            return .logoOrange
        case ThemeColor.pink.rawValue:
            return .logoPink
        case ThemeColor.purple.rawValue:
            return .logoPurple
        default:
            return .logoRed
        }
    }
    
    func selectTheme(_ theme: String) {
        currentTheme = theme
        UIApplication.shared.setAlternateIconName(theme) { _ in
            self.isShowSheet = false
        }
    }
    
    func createNewNote() -> NoteViewModel {
        let note: NoteFile = .init(
            title: "",
            notes: [NoteTextContent(text: "")],
            theme: self.currentTheme,
            createdAt: .now,
            modifiedAt: .now
        )
        return .init(data: note)
    }
}
