//
//  FolderViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI
import SwiftData

/// An enum representing the different ways to sort a list of notes.
enum SortBy: String {
    case edited = "Date Edited"
    case created  = "Date Created"
    case title  = "Title"
}

/// An enum representing the different ways to order a list of notes.
enum OrderBy {
    case ascending
    case descending
}

/// An enum representing the different data states for a list of notes.
enum DataState {
    case initiate
    case empty
    case notFound
}

/// An enum representing the different search states for a list of notes.
enum SearchState {
    case initiate
    case search
    case select
    case edit
}

extension FolderView {
    @Observable
    final class FolderViewModel {
        
        /// The model context for accessing and managing data models.
        var modelContext: ModelContext
        
        /// The current search text.
        var searchText = ""
        
        /// The folder data.
        var data: FolderResponse
        
        /// The title of the folder.
        var title = ""
        
        /// The icon of the folder.
        var icon = "💌"
        
        /// The ID of the folder.
        var folderId = ""
        
        /// The sort by option for the notes in the folder.
        var sortBy: SortBy = .edited
        
        /// The order by option for the notes in the folder.
        var orderBy: OrderBy = .ascending
        
        /// The current search state.
        var searchState: SearchState = .initiate
        
        /// The notes to be deleted.
        var notesForDelete: [NoteFileResponse] = []
        
        /// The list of themes.
        var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
        
        /// A boolean value that indicates whether the emoji picker is showing.
        var isShowEmojiPicker = false
        
        /// The alert property.
        var alert: MeMoAlertProperty = .init()
        
        /// A boolean value that indicates whether the alert is showing.
        var isShowAlert = false
        
        /// A boolean value that indicates whether the folder has been deleted.
        var isFolderDeleted = false
        
        /// The list of searched notes.
        var searchedNotes: [NoteFileResponse] {
            sortedNotesOrder()
        }
        
        /// The current data state.
        var state: DataState {
            if !searchText.isEmpty && searchedNotes.isEmpty {
                return .notFound
            } else if searchText.isEmpty && searchedNotes.isEmpty {
                return .empty
            } else {
                return .initiate
            }
        }
        
        /// The accent color for the folder.
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
        
        /// The secondary color for the folder.
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
        
        /// Initializes a new instance of the `FolderViewModel` class.
        ///
        /// - Parameters:
        ///     * modelContext: The model context for accessing and managing data models.
        ///     * data: The folder data.
        ///     * state: The initial search state.
        init(modelContext: ModelContext, data: FolderResponse, state: SearchState = .initiate) {
            self.modelContext = modelContext
            self.data = data
            self.searchState = state
            self.icon = data.icon.orEmpty()
            self.title = data.title.orEmpty()
            self.modelContext.autosaveEnabled = true
            self.folderId = data.id
        }
        
        /// Returns a description of the specified notes, joined by a space.
        ///
        /// - Parameter notes: The notes to describe.
        /// - Returns: A description of the notes.
        func description(from notes: [NoteResponse]) -> String {
            return notes.compactMap({ note in
                note.text
            }).joined(separator: " ")
        }
        
        /// Returns the accent color for the specified theme color.
        ///
        /// - Parameter color: The theme color.
        /// - Returns: The accent color.
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
        
        /// Returns the background color for the specified theme color.
        ///
        /// - Parameter color: The theme color.
        /// - Returns: The background color.
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
        
        /// Returns a boolean value that indicates whether the specified note is selected for deletion.
        ///
        /// - Parameter note: The note to check.
        /// - Returns: A boolean value that indicates whether the note is selected for deletion.
        func isForDelete(_ note: NoteFileResponse) -> Bool {
            notesForDelete.contains(where: { $0.id == note.id })
        }
        
        /// Returns a boolean value that indicates whether all notes are selected for deletion.
        ///
        /// - Returns: A boolean value that indicates whether all notes are selected for deletion.
        func isAllSelected() -> Bool {
            data.notes.allSatisfy({
                isForDelete($0)
            })
        }
        
        /// Toggles the selection of all notes.
        func toggleSelectAll() {
            if isAllSelected() {
                // If all notes are selected, clear the selection.
                notesForDelete = []
            } else {
                // If not all notes are selected, select all notes.
                notesForDelete = data.notes
            }
        }
        
        /// Toggles the selection of the specified note.
        ///
        /// - Parameter note: The note to toggle the selection of.
        func toggleSelection(_ note: NoteFileResponse) {
            if searchState == .select {
                // If the search state is select, toggle the selection of the note.
                if isForDelete(note) {
                    // If the note is selected, remove it from the selection.
                    notesForDelete.removeAll(where: { $0.id == note.id })
                } else {
                    // If the note is not selected, add it to the selection.
                    notesForDelete.append(note)
                }
            }
        }
        
        /// Deletes the selected notes from the folder.
        func deleteNotes() {
            // Create an empty string to store the ID of the note to be deleted.
            var noteIdForDelete = ""
            
            // If there are selected notes, delete them.
            if !notesForDelete.isEmpty {
                // Animate the deletion of the notes from the folder.
                withAnimation {
                    // Remove the selected notes from the folder's list of notes.
                    data.notes.removeAll { item in
                        return notesForDelete.contains { $0.id == item.id }
                    }
                    
                    // Delete the selected notes from the database.
                    do {
                        try notesForDelete.forEach { note in
                            // Store the ID of the note to be deleted.
                            noteIdForDelete = note.id
                            
                            // Delete the note from the database.
                            try modelContext.delete(model: NoteFileResponse.self, where: #Predicate { item in
                                item.id == noteIdForDelete
                            })
                        }
                    } catch(let error) {
                        // Print the error if it fails.
                        print("Error pas delete anyingg: \(error)")
                    }
                }
                
                // Clear the list of selected notes.
                notesForDelete = []
            }
        }
        
        /// Creates a new note in the folder.
        ///
        /// - Returns: A new note view model.
        func createFirstNote() -> NoteView.NoteViewModel {
            // Create a new note with the specified title, content, theme, and creation and modification dates.
            let note: NoteFileResponse = .init(
                title: "\(data.title.orEmpty())'s First Note",
                notes: [.init(type: NoteContentType.text.rawValue, text: "Write your first sentence in \(data.title.orEmpty())'s note", createdAt: .now)],
                theme: data.theme ?? "PURPLE",
                createdAt: .now,
                modifiedAt: .now,
                folder: data
            )
            
            // Add the new note to the folder's list of notes.
            data.notes.append(note)
            
            // Create a new note view model for the new note.
            return .init(modelContext: modelContext, data: note, isNewNote: true)
        }
        
        /// Creates a new note in the folder.
        ///
        /// - Returns: A new note view model.
        func createNewNote() -> NoteView.NoteViewModel {
            // Create a new note with the specified theme, creation, and modification dates.
            let note: NoteFileResponse = .init(
                title: "",
                notes: [],
                theme: data.theme ?? "PURPLE",
                createdAt: .now,
                modifiedAt: .now,
                folder: data
            )
            
            // Insert the new note into the database.
            modelContext.insert(note)
            
            // Create a new note view model for the new note.
            return .init(modelContext: modelContext, data: note, isNewNote: true)
        }
        
        /// Opens the specified note in a note view.
        ///
        /// - Parameter note: The note to open.
        /// - Returns: A new note view model.
        func openNote(_ note: NoteFileResponse) -> NoteView.NoteViewModel {
            // Create a new note view model for the specified note.
            return .init(modelContext: modelContext, data: note)
        }
        
        /// Opens the folder in edit mode if it is newly created and has no title.
        func editFolderWhenFirstCreated() {
            // If the folder has no title, open it in edit mode.
            if data.title.orEmpty().isEmpty {
                // Animate the opening of the folder in edit mode.
                withAnimation {
                    searchState = .edit
                }
            }
        }
        
        /// Returns a boolean value that indicates whether the done button should be disabled.
        ///
        /// - Returns: A boolean value that indicates whether the done button should be disabled.
        func disableDoneButton() -> Bool {
            // The done button should be disabled if the folder has no title or icon.
            return title.isEmpty || title.isWhitespace || icon.isEmpty || icon.isWhitespace
        }
        
        /// Updates the title of the folder.
        ///
        /// - Parameter title: The new title of the folder.
        func updateTitle(_ title: String) {
            // Set the title of the folder to the new title.
            data.title = title
        }
        
        /// Updates the icon of the folder.
        ///
        /// - Parameter icon: The new icon of the folder.
        func updateIcon(_ icon: String) {
            // Set the icon of the folder to the new icon.
            data.icon = icon
        }
        
        /// Updates the modified date of the folder.
        func updateModifiedDate() {
            // If the model context has changes, set the modified date of the folder to the current date.
            if modelContext.hasChanges {
                data.modifiedAt = .now
            }
        }
        
        /// Deletes the folder.
        func deleteFolder() {
            // If the folder has been deleted, delete it from the database.
            if isFolderDeleted {
                modelContext.delete(data)
            }
        }
        
        /// Saves the changes made to the folder.
        func saveChanges() {
            // Try to save the changes to the folder.
            do {
                try modelContext.save()
            } catch(let error) {
                // Print the error if it fails.
                print(error)
            }
        }
        
        /// Returns a sorted list of notes in the folder.
        ///
        /// - Returns: A sorted list of notes in the folder.
        private func sortedNotesOrder() -> [NoteFileResponse] {
            // If the search text is empty, return the notes sorted by the sort by and order by options.
            guard !searchText.isEmpty else {
                return data.notes.sorted(by: {
                    switch sortBy {
                    case .edited:
                        // Sort the notes by the modified date in ascending or descending order, depending on the order by option.
                        return orderBy == .ascending ?
                        $0.modifiedAt.orCurrentDate() > $1.modifiedAt.orCurrentDate() :
                        $0.modifiedAt.orCurrentDate() < $1.modifiedAt.orCurrentDate()
                    case .created:
                        // Sort the notes by the created date in ascending or descending order, depending on the order by option.
                        return orderBy == .ascending ?
                        $0.createdAt.orCurrentDate() > $1.createdAt.orCurrentDate() :
                        $0.createdAt.orCurrentDate() < $1.createdAt.orCurrentDate()
                    case .title:
                        // Sort the notes by the title in ascending or descending order, depending on the order by option.
                        return orderBy == .ascending ?
                        $0.title.orEmpty() < $1.title.orEmpty() :
                        $0.title.orEmpty() > $1.title.orEmpty()
                    }
                })
            }
            
            // Filter the notes by the search text.
            let filteredNotes = data.notes.filter { note in
                // Check if the note title or content contains the search text.
                note.title.orEmpty().lowercased().contains(searchText.lowercased())
                || note.notes.contains(where: { desc in
                    if (desc.type).orEmpty().isContent(of: .text) {
                        // Return true if the note content is text and contains the search text.
                        return desc.text.lowercased().contains(searchText.lowercased())
                    } else {
                        // Return false if the note content is not text.
                        return false
                    }
                })
            }
            
            // Return the filtered notes sorted by the sort by and order by options.
            return filteredNotes.sorted(by: {
                switch sortBy {
                case .edited:
                    // Sort the notes by the modified date in ascending or descending order, depending on the order by option.
                    return orderBy == .ascending ?
                    $0.modifiedAt.orCurrentDate() > $1.modifiedAt.orCurrentDate() :
                    $0.modifiedAt.orCurrentDate() < $1.modifiedAt.orCurrentDate()
                case .created:
                    // Sort the notes by the created date in ascending or descending order, depending on the order by option.
                    return orderBy == .ascending ?
                    $0.createdAt.orCurrentDate() > $1.createdAt.orCurrentDate() :
                    $0.createdAt.orCurrentDate() < $1.createdAt.orCurrentDate()
                case .title:
                    // Sort the notes by the title in ascending or descending order, depending on the order by option.
                    return orderBy == .ascending ?
                    $0.title.orEmpty() < $1.title.orEmpty() :
                    $0.title.orEmpty() > $1.title.orEmpty()
                }
            })
        }
        
        /// Shows an alert to the user to confirm whether they want to delete the folder.
        ///
        /// - Parameter completion: A closure to be executed after the user has confirmed or cancelled the deletion.
        func showDeleteFolderAlert(completion: @escaping () -> Void) {
            // Set the title of the alert.
            alert.title = "Delete This Folder?"
            
            // Set the primary button of the alert, which will delete the folder if the user taps it.
            alert.primaryButton = .init(
                text: "Sure",
                bgColor: accentColor,
                action: {
                    // Dismiss the alert.
                    self.isShowAlert = false
                    
                    // Set the folder as deleted.
                    self.isFolderDeleted = true
                    
                    // Delete the folder from the database.
                    self.deleteFolder()
                    
                    // Execute the completion closure.
                    completion()
                }
            )
            
            // Set the secondary button of the alert, which will dismiss the alert if the user taps it.
            alert.secondaryButton = .init(
                text: "Cancel",
                bgColor: .gray1,
                action: {
                    // Dismiss the alert.
                    self.isShowAlert = false
                }
            )
            
            // Show the alert.
            isShowAlert = true
        }
        
        /// Shows an alert to the user to confirm whether they want to delete the selected notes.
        func showDeleteNotesAlert() {
            // Set the title of the alert.
            alert.title = "Delete This Memo?"
            
            // Set the primary button of the alert, which will delete the selected notes if the user taps it.
            alert.primaryButton = .init(
                text: "Sure",
                bgColor: accentColor,
                action: {
                    // Dismiss the alert.
                    self.isShowAlert = false
                    
                    // Delete the selected notes from the database.
                    self.deleteNotes()
                }
            )
            
            // Set the secondary button of the alert, which will dismiss the alert if the user taps it.
            alert.secondaryButton = .init(
                text: "Cancel",
                bgColor: .gray1,
                action: {
                    // Dismiss the alert.
                    self.isShowAlert = false
                }
            )
            
            // Show the alert.
            isShowAlert = true
        }
        
    }
}
