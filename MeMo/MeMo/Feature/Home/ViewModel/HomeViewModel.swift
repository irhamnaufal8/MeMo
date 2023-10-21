//
//  HomeViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import SwiftData

extension HomeView {
    @Observable
    final class HomeViewModel {
        
        var modelContext: ModelContext
        
        var searchText = ""
        
        var recentNotes: [NoteFileResponse] = []
        var allNotes: [NoteFileResponse] = []
        var folders: [FolderResponse] = []
        
        var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
        @ObservationIgnored @AppStorage("current_theme") var currentTheme: String = ThemeColor.purple.rawValue
        
        var isShowSheet = false
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.modelContext.autosaveEnabled = true
        }
        
        func countNotes(from folder: FolderResponse) -> Int {
            folder.notes.count
        }
        
        func description(from notes: [NoteResponse]) -> String {
            return notes.compactMap({ note in
                note.text
            }).joined(separator: " ")
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
        
        func createNewNote() -> NoteView.NoteViewModel {
            let note: NoteFileResponse = .init(
                title: "",
                notes: [NoteResponse(type: .init(content: .text), text: "")],
                theme: self.currentTheme,
                createdAt: .now,
                modifiedAt: .now
            )
            
            modelContext.insert(note)
            return .init(modelContext: modelContext, data: note, isNewNote: true)
        }
        
        func createNewFolder() -> FolderView.FolderViewModel {
            let folder: FolderResponse = .init(
                title: "",
                icon: "💌",
                theme: currentTheme,
                notes: [],
                createdAt: .now,
                modifiedAt: .now
            )
            
            modelContext.insert(folder)
            
            return .init(modelContext: modelContext, data: folder)
        }
        
        func navigateToGlobal(state: SearchState) -> GlobalView.GlobalViewModel {
            return .init(modelContext: modelContext, data: allNotes, state: state, theme: currentTheme)
        }
        
        func openRecentNote(_ note: NoteFileResponse) -> NoteView.NoteViewModel {
            return .init(modelContext: modelContext, data: note)
        }
        
        func openFolder(_ folder: FolderResponse) -> FolderView.FolderViewModel {
            return .init(modelContext: modelContext, data: folder)
        }
        
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
        
        func saveChanges() {
            do {
                try modelContext.save()
            } catch(let error) {
                print(error)
            }
        }
    }
}
