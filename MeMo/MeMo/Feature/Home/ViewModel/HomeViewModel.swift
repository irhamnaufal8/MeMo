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
}
