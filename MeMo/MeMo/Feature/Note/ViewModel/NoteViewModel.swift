//
//  NoteViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI
import PhotosUI
import SwiftData

extension NoteView {
    
    /// The `NoteViewModel` class is a view model for the `NoteView` view. It is responsible for managing the state of the `NoteView` and providing data to the view.
    @Observable
    final class NoteViewModel {
        /// A ModelContext for accessing and managing data models.
        var modelContext: ModelContext
        
        /// The NoteFileResponse object that represents the note.
        var data: NoteFileResponse
        
        /// The title of the note.
        var title = ""
        
        /// Whether or not the note is new.
        var isNewNote: Bool
        
        /// The index of the current note in the list of notes.
        var currentIndex = 0
        
        /// Whether or not the tag sheet is displayed.
        var isShowTagSheet = false
        
        /// The new tag that the user is entering.
        var newTag = ""
        
        /// Whether or not the modified date is displayed.
        var isShowModified = true
        
        /// Whether or not the color picker is displayed.
        var isShowColorPicker = false
        
        /// Whether or not the bottom bar is displayed.
        var isShowBottomBar = false
        
        /// Whether or not the user is editing the title.
        var isEditTitle = false
        
        /// Whether or not the photo picker is displayed.
        var isShowPhotoPicker = false
        
        /// The selected image, if any.
        var selectedImage: PhotosPickerItem? = nil
        
        /// A list of theme colors.
        var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
        
        /// The current theme color.
        var currentTheme: String {
            get { data.theme.orEmpty() }
            set { data.theme = newValue }
        }
        
        /// The background color for the note, based on the current theme color.
        var bgColor: Color {
            switch data.theme {
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
        
        /// The `secondaryColor` property returns the secondary color for the note, based on the current theme color. The secondary color is a lighter version of the theme color.
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
                return .gray2
            }
        }

        /// The `accentColor` property returns the accent color for the note, based on the current theme color. The accent color is a contrasting color that is used to highlight important elements in the note.
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

        /// The `tagsText` property returns a string containing the tags for the note, separated by commas. If the note has no tags, the string "Empty" is returned.
        var tagsText: String {
            if let tags = data.tags, !tags.isEmpty {
                return tags.compactMap({
                    $0.text
                }) .joined(separator: ", ")
            } else {
                return "Empty"
            }
        }

        /// The `timeStampText` property returns a string containing the timestamp for the note, based on the current value of the `isShowModified` property. If `isShowModified` is `true`, the string "Last Modified at" is displayed. Otherwise, the string "Created at" is displayed.
        var timeStampText: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.locale = .current
            
            let createdDate = formatter.string(from: data.createdAt.orCurrentDate())
            let modifiedDate = formatter.string(from: data.modifiedAt.orCurrentDate())
            
            return isShowModified ? "Last Modified at \(modifiedDate)" : "Created at \(createdDate)"
        }
        
        /// Initializes a new instance of the `NoteViewModel` class.
        ///
        /// - Parameters:
        ///     * modelContext: A `ModelContext` object for accessing and managing data models.
        ///     * data: A `NoteFileResponse` object that represents the note.
        ///     * isNewNote: A boolean value that indicates whether or not the note is new.
        init(
            modelContext: ModelContext,
            data: NoteFileResponse,
            isNewNote: Bool = false
        ) {
            /// Stores the `modelContext` object.
            self.modelContext = modelContext
            
            /// Stores the `data` object.
            self.data = data
            
            /// Stores the `isNewNote` value.
            self.isNewNote = isNewNote
            
            /// Sets the title of the note.
            self.title = data.title.orEmpty()
            
            /// Disables autosave for the `modelContext` object.
            self.modelContext.autosaveEnabled = false
            
            /// Sorts the notes in the `data` object by creation date.
            data.notes.sort { first, second in
                first.createdAt < second.createdAt
            }
        }
        
        /// Deletes the specified tag from the note.
        ///
        /// - Parameter tag: The tag to delete.
        func deleteTag(_ tag: String) {
            /// Animates the deletion of the tag.
            withAnimation {
                /// Removes the tag from the `tags` array.
                data.tags?.removeAll(where: { $0.text == tag })
            }
        }
        
        /// Adds a new tag to the note.
        func addNewTag() {
            /// If the new tag is not empty, adds it to the `tags` array.
            if !newTag.isEmpty {
                let tag = TagResponse(text: newTag)
                withAnimation {
                    if let _ = data.tags {
                        data.tags?.append(tag)
                    } else {
                        data.tags = []
                        data.tags?.append(tag)
                    }
                    newTag = ""
                }
            }
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
        
        /// Returns the index of the specified note in the `data` object.
        ///
        /// - Parameter note: The note to find the index of.
        /// - Returns: The index of the note, or the current index if the note is not found.
        func getCurrentIndex(of note: NoteResponse) -> Int {
            return data.notes.firstIndex(where: { $0.id == note.id }) ?? currentIndex
        }

        /// Adds a new text note after the specified note.
        ///
        /// - Parameter note: The note to add the new text note after.
        func addNoteText(after note: NoteResponse) {
            let noteText = NoteResponse(type: .init(content: .text), text: "")
            withAnimation {
                data.notes.insert(noteText, at: currentIndex + 1)
            }
        }

        /// Adds a new text note to the beginning of the note list.
        func addFirstText() {
            guard data.notes.isEmpty else { return }
            let noteText = NoteResponse(type: .init(content: .text), text: "")
            data.notes.append(noteText)
        }

        /// Adds a new text note to the end of the note list, if the last note is an image or the note list is empty.
        func addNoteTextOnLast() {
            guard let note = data.notes.last,
                  (note.type.orEmpty()).isContent(of: .image) || data.notes.isEmpty else { return }
            let noteText = NoteResponse(type: .init(content: .text), text: "")
            withAnimation {
                data.notes.append(noteText)
            }
        }

        /// Adds an image note to the note list at the current index.
        ///
        /// - Parameter photo: The photo to add to the note list.
        func addNoteImage(with photo: PhotosPickerItem?) async {
            if let data = try? await photo?.loadTransferable(type: Data.self) {
                let noteImage = NoteResponse(type: .init(content: .image), text: "", image: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    withAnimation {
                        self.data.notes[self.currentIndex] = noteImage
                    }
                    self.selectedImage = nil
                }
                return
            }
        }
        
        /// Adds a new list note to the note list at the current index.
        func addNoteList() {
            let noteList = NoteResponse(type: .init(content: .list), text: data.notes[currentIndex].text)
            withAnimation {
                data.notes[currentIndex] = noteList
            }
        }

        /// Adds a new list note to the end of the note list.
        func addNextNoteList() {
            let noteList = NoteResponse(type: .init(content: .list), text: "")
            withAnimation {
                data.notes.insert(noteList, at: currentIndex+1)
            }
        }

        /// Adds a new bullet list note after the specified note.
        ///
        /// - Parameter note: The note to add the new bullet list note after.
        func addNextBulletList(after note: NoteResponse) {
            let bulletList = NoteResponse(type: .init(content: .bulletList), text: "")
            withAnimation {
                if data.notes[currentIndex].text.isEmpty {
                    // Turn the current note into a text note if it is empty.
                    turnIntoText(if: true)
                    // Add a new text note after the specified note.
                    addNoteText(after: note)
                } else {
                    // Add a new bullet list note after the current note.
                    data.notes.insert(bulletList, at: currentIndex+1)
                }
            }
        }

        /// Deletes the current line, if it is empty.
        ///
        /// - Parameter isEmpty: A boolean value that indicates whether the current line is empty.
        func deleteCurrentLine(if isEmpty: Bool) {
            guard data.notes.count > 1 else { return }
            if isEmpty {
                // Remove the current note from the note list.
                data.notes.remove(at: currentIndex)
            }
        }

        /// Deletes the specified image note from the note list.
        ///
        /// - Parameter image: The image note to delete.
        func deleteNoteImage(_ image: NoteResponse) {
            // Set the current index to the index of the image note.
            currentIndex = getCurrentIndex(of: image)
            // Turn the current note into a text note.
            turnIntoText(if: true)
        }

        /// Turns the current note into a text note, if it is not empty.
        ///
        /// - Parameter isEmpty: A boolean value that indicates whether the current note is empty.
        func turnIntoText(if isEmpty: Bool) {
            if isEmpty {
                // Set the current note to a new text note.
                data.notes[currentIndex] = NoteResponse(type: .init(content: .text), text: "")
            }
        }
        
        /// Turns the current note into a bullet list note, if it starts with "- ".
        func turnIntoBulletList() {
            if data.notes[currentIndex].text.hasPrefix("- ") {
                // Set the current note to a new bullet list note, with the text without the first two characters.
                data.notes[currentIndex] = NoteResponse(type: .init(content: .bulletList), text: String(data.notes[currentIndex].text.dropFirst(2)))
            }
        }

        /// Checks if the previous note is not a checklist.
        ///
        /// - Parameter note: The note to check the previous note of.
        /// - Returns: A boolean value that indicates whether the previous note is not a checklist.
        func prevIsNotCheckList(_ note: NoteResponse) -> Bool {
            // Get the current index of the note.
            let current = getCurrentIndex(of: note)

            // Guard against the current index being 0.
            guard current > 0 else { return false }

            // Get the previous note.
            let previousNote = data.notes[current - 1]

            // Return a boolean value that indicates whether the previous note is not a checklist.
            return !((previousNote.type).orEmpty().isContent(of: .list))
        }

        /// Checks if the next note is not a checklist.
        ///
        /// - Parameter note: The note to check the next note of.
        /// - Returns: A boolean value that indicates whether the next note is not a checklist.
        func nextIsNotCheckList(_ note: NoteResponse) -> Bool {
            // Get the current index of the note.
            let current = getCurrentIndex(of: note)

            // Guard against the current index being equal to the last index of the note list.
            guard current < data.notes.count - 1 else { return false }

            // Get the next note.
            let nextNote = data.notes[current + 1]

            // Return a boolean value that indicates whether the next note is not a checklist.
            return !(nextNote.type.orEmpty().isContent(of: .list))
        }

        /// Updates the title of the note.
        ///
        /// - Parameter title: The new title for the note.
        func updateTitle(_ title: String) {
            // Set the title of the note to the new title.
            data.title = title
        }

        /// Updates the modified date of the note.
        func updateModifiedDate() {
            // If the model context has changes, set the modified date of the note to the current date.
            if modelContext.hasChanges {
                data.modifiedAt = .now
            }
        }

        /// Saves the changes made to the note.
        func saveChanges() {
            // Try to save the changes to the note.
            do {
                try modelContext.save()
            } catch(let error) {
                // Print the error if it fails.
                print(error)
            }
        }

        /// Sorts the content of the note.
        func sortContent() {
            // Sort the notes in the note list by creation date.
            data.notes.sort { first, second in
                first.createdAt < second.createdAt
            }
        }
    }
}
