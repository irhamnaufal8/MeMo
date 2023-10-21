//
//  HomeViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import SwiftData

extension HomeView {
    
    /// The `HomeViewModel` class is a view model for the `HomeView` view. It is responsible for managing the state of the `HomeView` and providing data to the view.
    @Observable
    final class HomeViewModel {
        
        /// A ModelContext for accessing and managing data models.
        var modelContext: ModelContext
        
        /// The search text entered by the user.
        var searchText = ""
        
        /// A list of recent notes.
        var recentNotes: [NoteFileResponse] = []
        
        /// A list of all notes.
        var allNotes: [NoteFileResponse] = []
        
        /// A list of folders.
        var folders: [FolderResponse] = []
        
        /// A list of theme colors.
        var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
        
        /// The currently selected theme color.
        @ObservationIgnored @AppStorage("current_theme") var currentTheme: String = ThemeColor.purple.rawValue
        
        /// Whether or not the note sheet is displayed.
        var isShowSheet = false
        
        /// Initializes a new HomeViewModel object.
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.modelContext.autosaveEnabled = true
        }
        
        /// Counts the number of notes in a folder.
        func countNotes(from folder: FolderResponse) -> Int {
            folder.notes.count
        }
        
        /// Returns a description of a list of notes.
        func description(from notes: [NoteResponse]) -> String {
            return notes.compactMap({ note in
                note.text
            }).joined(separator: " ")
        }
        
        /// Returns a Color object for a given theme color.
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

        /// Returns the secondary color for the given theme color.
        /// The secondary color is a lighter version of the theme color.
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

        /// Returns the accent color for the given theme color.
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

        /// Returns the app icon for the given theme color.
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
        
        /// Selects the specified theme.
        func selectTheme(_ theme: String) {
            currentTheme = theme

            // Sets the alternate icon for the app to the specified theme.
            UIApplication.shared.setAlternateIconName(theme) { _ in
                // Hides the note sheet.
                self.isShowSheet = false
            }
        }

        /// Creates a new note with the specified theme.
        func createNewNote() -> NoteView.NoteViewModel {
            let note: NoteFileResponse = .init(
                title: "",
                notes: [NoteResponse(type: .init(content: .text), text: "")],
                theme: self.currentTheme,
                createdAt: .now,
                modifiedAt: .now
            )

            // Inserts the new note into the data model.
            modelContext.insert(note)

            // Returns a NoteView.NoteViewModel object for the new note.
            return .init(modelContext: modelContext, data: note, isNewNote: true)
        }

        /// Creates a new folder with the specified theme.
        func createNewFolder() -> FolderView.FolderViewModel {
            let folder: FolderResponse = .init(
                title: "",
                icon: "💌",
                theme: currentTheme,
                notes: [],
                createdAt: .now,
                modifiedAt: .now
            )

            // Inserts the new folder into the data model.
            modelContext.insert(folder)

            // Returns a FolderView.FolderViewModel object for the new folder.
            return .init(modelContext: modelContext, data: folder)
        }
        
        /// Navigates to the global view with the specified search state./
        func navigateToGlobal(state: SearchState) -> GlobalView.GlobalViewModel {
            return .init(modelContext: modelContext, data: allNotes, state: state, theme: currentTheme)
        }

        /// Opens the specified recent note./
        func openRecentNote(_ note: NoteFileResponse) -> NoteView.NoteViewModel {
            return .init(modelContext: modelContext, data: note)
        }

        /// Opens the specified folder./
        func openFolder(_ folder: FolderResponse) -> FolderView.FolderViewModel {
            return .init(modelContext: modelContext, data: folder)
        }

        /// Fetches all notes from the data model and updates the recent notes and folders lists./
        func getAllNotes() {
            do {
                let descriptor = FetchDescriptor<NoteFileResponse>(
                    sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
                )

                allNotes = try modelContext.fetch(descriptor)
                recentNotes = Array(allNotes.prefix(5))

                for note in allNotes {
                    guard let folder = note.folder, !folders.contains(where: { $0.id == folder.id }) else {
                        continue
                    }
                    folders.append(folder)
                }
            } catch(let error) {
                print("Fetch recent notes failed: \(error)")
            }
        }

        /// Saves the changes made to the data model./
        func saveChanges() {
            do {
                try modelContext.save()
            } catch(let error) {
                print(error)
            }
        }

    }
}
