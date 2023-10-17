//
//  FolderViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI

enum SortBy: String {
    case edited = "Date Edited"
    case created  = "Date Created"
    case title  = "Title"
}

enum OrderBy {
    case ascending
    case descending
}

enum DataState {
    case initiate
    case empty
    case notFound
}

final class FolderViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var data: Folder
    
    @Published var sortBy: SortBy = .edited
    @Published var orderBy: OrderBy = .ascending
    
    @Published var isSelecting = false
    @Published var isEditing = false
    
    @Published var notesForDelete: [NoteFile] = []
    
    var searchedNotes: [NoteFile] {
        guard !searchText.isEmpty else {
            return data.notes.sorted(by: {
                switch sortBy {
                case .edited:
                    orderBy == .ascending ?
                    $0.modifiedAt.orCurrentDate() > $1.modifiedAt.orCurrentDate() :
                    $0.modifiedAt.orCurrentDate() < $1.modifiedAt.orCurrentDate()
                case .created:
                    orderBy == .ascending ?
                    $0.createdAt.orCurrentDate() > $1.createdAt.orCurrentDate() :
                    $0.createdAt.orCurrentDate() < $1.createdAt.orCurrentDate()
                case .title:
                    orderBy == .ascending ?
                    $0.title < $1.title :
                    $0.title > $1.title
                }
            })
        }
        
        return data.notes.filter { note in
            note.title.lowercased().contains(searchText.lowercased())
            || note.notes.contains(where: { desc in
                if let desc = desc as? NoteTextContent {
                    return desc.text.lowercased().contains(searchText.lowercased())
                } else {
                    return false
                }
            })
        }.sorted(by: {
            switch sortBy {
            case .edited:
                orderBy == .ascending ?
                $0.modifiedAt.orCurrentDate() > $1.modifiedAt.orCurrentDate() :
                $0.modifiedAt.orCurrentDate() < $1.modifiedAt.orCurrentDate()
            case .created:
                orderBy == .ascending ?
                $0.createdAt.orCurrentDate() > $1.createdAt.orCurrentDate() :
                $0.createdAt.orCurrentDate() < $1.createdAt.orCurrentDate()
            case .title:
                orderBy == .ascending ?
                $0.title < $1.title :
                $0.title > $1.title
            }
        })
    }
    
    var state: DataState {
        if !searchText.isEmpty && searchedNotes.isEmpty {
            return .notFound
        } else if searchText.isEmpty && searchedNotes.isEmpty {
            return .empty
        } else {
            return .initiate
        }
    }
    
    var accentColor: Color {
        switch data.theme {
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
            return .black2
        }
    }
    
    init(data: Folder) {
        self.data = data
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
    
    func isForDelete(_ note: NoteFile) -> Bool {
        notesForDelete.contains(where: { $0.id == note.id })
    }
    
    func isAllSelected() -> Bool {
        searchedNotes.allSatisfy({
            isForDelete($0)
        })
    }
    
    func toggleSelectAll() {
        if isAllSelected() {
            notesForDelete = []
        } else {
            notesForDelete = searchedNotes
        }
    }
    
    func toggleSelection(_ note: NoteFile) {
        if isSelecting {
            isForDelete(note) ?
            notesForDelete.removeAll(where: { $0.id == note.id }) :
            notesForDelete.append(note)
        }
    }
    
    func deleteNotes() {
        if !notesForDelete.isEmpty {
            withAnimation {
                data.notes.removeAll { item in
                    return notesForDelete.contains { $0.id == item.id }
                }
            }
        }
    }
}
