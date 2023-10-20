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

enum SearchState {
    case initiate
    case search
    case select
    case edit
}

final class FolderViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var data: FolderResponse
    @Published var isMainFolder: Bool
    
    @Published var title = ""
    @Published var icon = "💌"
    
    @Published var sortBy: SortBy = .edited
    @Published var orderBy: OrderBy = .ascending
    
    @Published var searchState: SearchState = .initiate
    
    @Published var notesForDelete: [NoteFileResponse] = []
    
    @Published var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
    
    @Published var isShowEmojiPicker = false
    
    var searchedNotes: [NoteFileResponse] {
        guard !searchText.isEmpty else {
            return (data.notes ?? []).sorted(by: {
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
                    $0.title.orEmpty() < $1.title.orEmpty() :
                    $0.title.orEmpty() > $1.title.orEmpty()
                }
            })
        }
        
        return (data.notes ?? []).filter { note in
            note.title.orEmpty().lowercased().contains(searchText.lowercased())
            || (note.notes ?? []).contains(where: { desc in
                if (desc.type).orEmpty().isContent(of: .text) {
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
                $0.title.orEmpty() < $1.title.orEmpty() :
                $0.title.orEmpty() > $1.title.orEmpty()
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
    
    var secondaryColor: Color {
        switch data.theme {
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
            return .black2
        }
    }
    
    init(data: FolderResponse, isMainFolder: Bool, state: SearchState = .initiate) {
        self.data = data
        self.isMainFolder = isMainFolder
        self.searchState = state
        self.icon = data.icon.orEmpty()
        self.title = data.title.orEmpty()
    }
    
    func description(from notes: [NoteResponse]) -> String {
        var description = ""
        description = notes.compactMap({ note in
            if note.type.orEmpty().isContent(of: .text) {
                note.text
            } else {
                ""
            }
        }).joined(separator: " ")
        
        return description
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
            return .black2
        }
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
    
    func isForDelete(_ note: NoteFileResponse) -> Bool {
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
    
    func toggleSelection(_ note: NoteFileResponse) {
        if searchState == .select {
            isForDelete(note) ?
            notesForDelete.removeAll(where: { $0.id == note.id }) :
            notesForDelete.append(note)
        }
    }
    
    func deleteNotes() {
        if !notesForDelete.isEmpty {
            withAnimation {
                data.notes?.removeAll { item in
                    return notesForDelete.contains { $0.id == item.id }
                }
            }
            
            notesForDelete = []
        }
    }
    
    func createNewNote() -> NoteViewModel {
        let note: NoteFileResponse = .init(
            title: "",
            notes: [],
            theme: data.theme ?? "PURPLE",
            createdAt: .now,
            modifiedAt: .now
        )
        return .init(data: note, isNewNote: true)
    }
    
    func editFolderWhenFirstCreated() {
        if data.title.orEmpty().isEmpty {
            withAnimation {
                searchState = .edit
            }
        }
    }
    
    func disableDoneButton() -> Bool {
        title.isEmpty || title.isWhitespace || icon.isEmpty || icon.isWhitespace
    }
}
