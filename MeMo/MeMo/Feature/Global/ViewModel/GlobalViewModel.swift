//
//  GlobalViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 21/10/23.
//

import SwiftData
import SwiftUI

extension GlobalView {
    @Observable
    final class GlobalViewModel {
        
        var modelContext: ModelContext
        
        var searchText = ""
        var data: [NoteFileResponse]
        
        var sortBy: SortBy = .edited
        var orderBy: OrderBy = .ascending
        
        var searchState: SearchState = .initiate
        
        var notesForDelete: [NoteFileResponse] = []
        
        var theme: String
        
        var searchedNotes: [NoteFileResponse] {
            sortedNotesOrder()
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
            switch theme {
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
            switch theme {
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
        
        init(modelContext: ModelContext, data: [NoteFileResponse], state: SearchState = .initiate, theme: String) {
            self.modelContext = modelContext
            self.data = data
            self.searchState = state
            self.theme = theme
            self.modelContext.autosaveEnabled = true
        }
        
        func description(from notes: [NoteResponse]) -> String {
            return notes.compactMap({ note in
                note.text
            }).joined(separator: " ")
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
            data.allSatisfy({
                isForDelete($0)
            })
        }
        
        func toggleSelectAll() {
            if isAllSelected() {
                notesForDelete = []
            } else {
                notesForDelete = data
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
            var noteIdForDelete = ""
            if !notesForDelete.isEmpty {
                withAnimation {
                    data.removeAll { item in
                        return notesForDelete.contains { $0.id == item.id }
                    }
                    
                    do {
                        try notesForDelete.forEach { note in
                            noteIdForDelete = note.id
                            try modelContext.delete(model: NoteFileResponse.self, where: #Predicate { item in
                                item.id == noteIdForDelete
                            })
                        }
                    } catch(let error) {
                        print("Error pas delete anyingg: \(error)")
                    }
                }
                
                notesForDelete = []
            }
        }
        
        func createNewNote() -> NoteView.NoteViewModel {
            let note: NoteFileResponse = .init(
                title: "",
                notes: [],
                theme: theme,
                createdAt: .now,
                modifiedAt: .now
            )
            
            modelContext.insert(note)
            return .init(modelContext: modelContext, data: note, isNewNote: true)
        }
        
        func openNote(_ note: NoteFileResponse) -> NoteView.NoteViewModel {
            return .init(modelContext: modelContext, data: note)
        }
        
        func saveChanges() {
            do {
                try modelContext.save()
            } catch(let error) {
                print(error)
            }
        }
        
        private func sortedNotesOrder() -> [NoteFileResponse] {
            guard !searchText.isEmpty else {
                return data.sorted(by: {
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
            
            return data.filter { note in
                note.title.orEmpty().lowercased().contains(searchText.lowercased())
                || note.notes.contains(where: { desc in
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
    }
}
