//
//  GlobalViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 21/10/23.
//

import SwiftData
import SwiftUI

extension GlobalView {
    /// A global view model that provides data and functionality for the entire app.
    @Observable
    final class GlobalViewModel {
        
        /// The model context used to access and manage data models.
        var modelContext: ModelContext
        
        /// The search text entered by the user.
        var searchText = ""
        
        /// The list of all notes in the app.
        var data: [NoteFile]
        
        /// The current sort by option for the notes list.
        var sortBy: SortBy = .edited
        
        /// The current order by option for the notes list.
        var orderBy: OrderBy = .ascending
        
        /// The current search state of the app.
        var searchState: SearchState = .initiate
        
        /// The list of notes selected for deletion.
        var notesForDelete: [NoteFile] = []
        
        /// The current theme of the app.
        var theme: String
        
        /// The alert property used to show alerts to the user.
        var alert: MeMoAlertProperty = .init()
        
        /// A boolean value that indicates whether an alert is currently being shown.
        var isShowAlert = false
        
        /// The list of notes that match the search text and are sorted by the sort by and order by options.
        var searchedNotes: [NoteFile] {
            sortedNotesOrder()
        }
        
        /// The current data state of the app.
        var state: DataState {
            if !searchText.isEmpty && searchedNotes.isEmpty {
                return .notFound
            } else if searchText.isEmpty && searchedNotes.isEmpty {
                return .empty
            } else {
                return .initiate
            }
        }
        
        /// The accent color of the app.
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
        
        /// The secondary color of the app.
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
        
        /// Initializes a new instance of the `GlobalViewModel` class.
        ///
        /// - Parameters:
        ///     * modelContext: The model context used to access and manage data models.
        ///     * data: The list of all notes in the app.
        ///     * state: The initial search state of the app.
        ///     * theme: The initial theme of the app.
        init(modelContext: ModelContext, data: [NoteFile], state: SearchState = .initiate, theme: String) {
            self.modelContext = modelContext
            self.data = data
            self.searchState = state
            self.theme = theme
            self.modelContext.autosaveEnabled = true
        }
        
        /// Returns a description of the specified notes, consisting of the text of each note joined by a space.
        ///
        /// - Parameter notes: The notes to describe.
        /// - Returns: A description of the specified notes.
        func description(from notes: [NoteContent]) -> String {
            // Return a string consisting of the text of each note joined by a space.
            return notes.compactMap({ note in
                note.text
            }).joined(separator: " ")
        }
        
        /// Returns the accent color for the specified theme color.
        ///
        /// - Parameter color: The theme color.
        /// - Returns: The accent color for the specified theme color.
        func accentColor(from color: String) -> Color {
            // Switch on the theme color and return the corresponding accent color.
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
                // Return the default accent color if the theme color is not recognized.
                return .black2
            }
        }
        
        /// Returns the background color for the specified theme color.
        ///
        /// - Parameter color: The theme color.
        /// - Returns: The background color for the specified theme color.
        func bgColor(from color: String) -> Color {
            // Switch on the theme color and return the corresponding background color.
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
                // Return the default background color if the theme color is not recognized.
                return .gray2
            }
        }
        
        /// Returns a boolean value that indicates whether the specified note is selected for deletion.
        ///
        /// - Parameter note: The note to check.
        /// - Returns: A boolean value that indicates whether the specified note is selected for deletion.
        func isForDelete(_ note: NoteFile) -> Bool {
            // Check if the note is in the list of notes selected for deletion.
            return notesForDelete.contains(where: { $0.id == note.id })
        }
        
        /// Returns a boolean value that indicates whether all notes are selected for deletion.
        ///
        /// - Returns: A boolean value that indicates whether all notes are selected for deletion.
        func isAllSelected() -> Bool {
            // Check if all notes in the data list are in the list of notes selected for deletion.
            return data.allSatisfy({
                isForDelete($0)
            })
        }
        
        /// Toggles the selection of all notes.
        func toggleSelectAll() {
            // If all notes are selected, clear the selection.
            if isAllSelected() {
                notesForDelete = []
            } else {
                // If not all notes are selected, select all notes.
                notesForDelete = data
            }
        }
        
        /// Toggles the selection of the specified note.
        ///
        /// - Parameter note: The note to toggle the selection of.
        func toggleSelection(_ note: NoteFile) {
            // If the search state is select, toggle the selection of the note.
            if searchState == .select {
                // If the note is selected, remove it from the selection.
                if isForDelete(note) {
                    notesForDelete.removeAll(where: { $0.id == note.id })
                } else {
                    // If the note is not selected, add it to the selection.
                    notesForDelete.append(note)
                }
            }
        }
        
        /// Deletes the notes that have been selected for deletion.
        func deleteNotes() {
            // Create a variable to store the ID of the note to be deleted.
            var noteIdForDelete = ""
            
            // If there are notes selected for deletion, remove them from the data list and delete them from the database.
            if !notesForDelete.isEmpty {
                // Animate the removal of the notes from the data list.
                withAnimation {
                    // Remove the notes from the data list.
                    data.removeAll { item in
                        // Return true if the note is in the list of notes selected for deletion.
                        return notesForDelete.contains { $0.id == item.id }
                    }
                    
                    // Try to delete the notes from the database.
                    do {
                        // Iterate over the list of notes selected for deletion and delete each note from the database.
                        try notesForDelete.forEach { note in
                            // Store the ID of the note to be deleted in the variable.
                            noteIdForDelete = note.id
                            
                            // Delete the note from the database using a predicate to filter for the note by ID.
                            try modelContext.delete(model: NoteFile.self, where: #Predicate { item in
                                item.id == noteIdForDelete
                            })
                        }
                    } catch(let error) {
                        // Print an error message if the deletion fails.
                        print("Error pas delete anyingg: \(error)")
                    }
                }
                
                // Clear the list of notes selected for deletion.
                notesForDelete = []
            }
        }
        
        /// Creates a new note.
        ///
        /// - Returns: A new note view model for the new note.
        func createNewNote() -> NoteView.NoteViewModel {
            // Create a new note with an empty title, an empty list of notes, the current theme, and the current date and time for both the created at and modified at properties.
            let note: NoteFile = .init(
                title: "",
                notes: [],
                theme: theme,
                createdAt: .now,
                modifiedAt: .now
            )
            
            // Insert the new note into the database.
            modelContext.insert(note)
            
            // Create a new note view model for the new note.
            return .init(modelContext: modelContext, data: note, isNewNote: true)
        }
        
        /// Opens the specified note.
        ///
        /// - Parameter note: The note to open.
        /// - Returns: A new note view model for the specified note.
        func openNote(_ note: NoteFile) -> NoteView.NoteViewModel {
            // Create a new note view model for the specified note.
            return .init(modelContext: modelContext, data: note)
        }
        
        /// Saves the changes made to the notes in the database.
        func saveChanges() {
            // Try to save the changes to the notes in the database.
            do {
                try modelContext.save()
            } catch(let error) {
                // Print an error message if the save fails.
                print(error)
            }
        }
        
        /// Returns a sorted list of notes in the folder.
        ///
        /// - Returns: A sorted list of notes in the folder.
        private func sortedNotesOrder() -> [NoteFile] {
            // If the search text is empty, return the notes sorted by the sort by and order by options.
            guard !searchText.isEmpty else {
                return data.sorted(by: {
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
            let filteredNotes = data.filter { note in
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
