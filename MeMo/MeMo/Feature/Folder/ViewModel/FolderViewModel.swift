//
//  FolderViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI
import SwiftData

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

extension FolderView {
    @Observable
    final class FolderViewModel {
        
        var modelContext: ModelContext
        
        var searchText = ""
        var data: FolderResponse
        
        var title = ""
        var icon = "💌"
        var folderId = ""
        
        var sortBy: SortBy = .edited
        var orderBy: OrderBy = .ascending
        
        var searchState: SearchState = .initiate
        
        var notesForDelete: [NoteFileResponse] = []
        
        var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
        
        var isShowEmojiPicker = false
        
        var alert: MeMoAlertProperty = .init()
        var isShowAlert = false
        var isFolderDeleted = false
        
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
        
        init(modelContext: ModelContext, data: FolderResponse, state: SearchState = .initiate) {
            self.modelContext = modelContext
            self.data = data
            self.searchState = state
            self.icon = data.icon.orEmpty()
            self.title = data.title.orEmpty()
            self.modelContext.autosaveEnabled = true
            self.folderId = data.id
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
            data.notes.allSatisfy({
                isForDelete($0)
            })
        }
        
        func toggleSelectAll() {
            if isAllSelected() {
                notesForDelete = []
            } else {
                notesForDelete = data.notes
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
                    data.notes.removeAll { item in
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
        
        func createFirstNote() -> NoteView.NoteViewModel {
            let note: NoteFileResponse = .init(
                title: "\(data.title.orEmpty())'s First Note",
                notes: [.init(type: NoteContentType.text.rawValue, text: "Write your first sentence in \(data.title.orEmpty())'s note", createdAt: .now)],
                theme: data.theme ?? "PURPLE",
                createdAt: .now,
                modifiedAt: .now,
                folder: data
            )
            
            data.notes.append(note)
            return .init(modelContext: modelContext, data: note, isNewNote: true)
        }
        
        func createNewNote() -> NoteView.NoteViewModel {
            let note: NoteFileResponse = .init(
                title: "",
                notes: [],
                theme: data.theme ?? "PURPLE",
                createdAt: .now,
                modifiedAt: .now,
                folder: data
            )
            
            modelContext.insert(note)
            return .init(modelContext: modelContext, data: note, isNewNote: true)
        }
        
        func openNote(_ note: NoteFileResponse) -> NoteView.NoteViewModel {
            return .init(modelContext: modelContext, data: note)
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
        
        func updateTitle(_ title: String) {
            data.title = title
        }
        
        func updateIcon(_ icon: String) {
            data.icon = icon
        }
        
        func updateModifiedDate() {
            if modelContext.hasChanges {
                data.modifiedAt = .now
            }
        }
        
        func deleteFolder() {
            if isFolderDeleted {
                modelContext.delete(data)
            }
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
                        $0.title.orEmpty() < $1.title.orEmpty() :
                        $0.title.orEmpty() > $1.title.orEmpty()
                    }
                })
            }
            
            return data.notes.filter { note in
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
        
        func showDeleteFolderAlert(completion: @escaping () -> Void) {
            alert.title = "Delete This Folder?"
            alert.primaryButton = .init(
                text: "Sure",
                bgColor: accentColor,
                action: {
                    self.isShowAlert = false
                    self.isFolderDeleted = true
                    self.deleteFolder()
                    completion()
                }
            )
            alert.secondaryButton = .init(
                text: "Cancel",
                bgColor: .gray1,
                action: {
                    self.isShowAlert = false
                }
            )
            
            isShowAlert = true
        }
        
        func showDeleteNotesAlert() {
            alert.title = "Delete This Memo?"
            alert.primaryButton = .init(
                text: "Sure",
                bgColor: accentColor,
                action: {
                    self.isShowAlert = false
                    self.deleteNotes()
                }
            )
            alert.secondaryButton = .init(
                text: "Cancel",
                bgColor: .gray1,
                action: {
                    self.isShowAlert = false
                }
            )
            
            isShowAlert = true
        }
    }
}
