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
    
    @Observable
    final class NoteViewModel {
        var modelContext: ModelContext
        var data: NoteFileResponse
        
        var title = ""
        
        var isNewNote: Bool
        
        var currentIndex = 0
        
        var isShowTagSheet = false
        var newTag = ""
        var isShowModified = true
        
        var isShowColorPicker = false
        var isShowBottomBar = false
        var isEditTitle = false
        
        var isShowPhotoPicker = false
        var selectedImage: PhotosPickerItem? = nil
        
        var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
        var currentTheme: String {
            get { data.theme.orEmpty() }
            set { data.theme = newValue }
        }
        
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
        
        var tagsText: String {
            if let tags = data.tags, !tags.isEmpty {
                return tags.compactMap({
                    $0.text
                }) .joined(separator: ", ")
            } else {
                return "Empty"
            }
        }
        
        var timeStampText: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.locale = .current
            
            let createdDate = formatter.string(from: data.createdAt.orCurrentDate())
            let modifiedDate = formatter.string(from: data.modifiedAt.orCurrentDate())
            
            return isShowModified ? "Last Modified at \(modifiedDate)" : "Created at \(createdDate)"
        }
        
        init(
            modelContext: ModelContext,
            data: NoteFileResponse,
            isNewNote: Bool = false
        ) {
            self.modelContext = modelContext
            self.data = data
            self.isNewNote = isNewNote
            self.title = data.title.orEmpty()
            self.modelContext.autosaveEnabled = false
            self.data.notes.sort { first, second in
                first.createdAt < second.createdAt
            }
        }
        
        func deleteTag(_ tag: String) {
            withAnimation {
                data.tags?.removeAll(where: { $0.text == tag })
            }
        }
        
        func addNewTag() {
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
        
        func getCurrentIndex(of note: NoteResponse) -> Int {
            return data.notes.firstIndex(where: { $0.id == note.id }) ?? currentIndex
        }
        
        func addNoteText(after note: NoteResponse) {
            let noteText = NoteResponse(type: .init(content: .text), text: "")
            withAnimation {
                data.notes.insert(noteText, at: currentIndex + 1)
            }
        }
        
        func addFirstText() {
            guard data.notes.isEmpty else { return }
            let noteText = NoteResponse(type: .init(content: .text), text: "")
            data.notes.append(noteText)
        }
        
        func addNoteTextOnLast() {
            guard let note = data.notes.last,
                  (note.type.orEmpty()).isContent(of: .image) || data.notes.isEmpty else { return }
            let noteText = NoteResponse(type: .init(content: .text), text: "")
            withAnimation {
                data.notes.append(noteText)
            }
        }
        
        // FIXME: CHANGE LOGIC TO UPLOAD IMAGE
        func addNoteImage(with photo: PhotosPickerItem?) async {
            if let data = try? await photo?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    let noteImage = NoteResponse(type: .init(content: .image), text: "")
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
        }
        
        func addNoteList() {
            let noteList = NoteResponse(type: .init(content: .list), text: data.notes[currentIndex].text)
            withAnimation {
                data.notes[currentIndex] = noteList
            }
        }
        
        func addNextNoteList() {
            let noteList = NoteResponse(type: .init(content: .list), text: "")
            withAnimation {
                data.notes.insert(noteList, at: currentIndex+1)
            }
        }
        
        func addNextBulletList(after note: NoteResponse) {
            let bulletList = NoteResponse(type: .init(content: .bulletList), text: "")
            withAnimation {
                if data.notes[currentIndex].text.isEmpty {
                    turnIntoText(if: true)
                    addNoteText(after: note)
                } else {
                    data.notes.insert(bulletList, at: currentIndex+1)
                }
            }
        }
        
        func deleteCurrentLine(if isEmpty: Bool) {
            guard data.notes.count > 1 else { return }
            if isEmpty {
                data.notes.remove(at: currentIndex)
            }
        }
        
        func deleteNoteImage(_ image: NoteResponse) {
            currentIndex = getCurrentIndex(of: image)
            turnIntoText(if: true)
        }
        
        func turnIntoText(if isEmpty: Bool) {
            if isEmpty {
                data.notes[currentIndex] = NoteResponse(type: .init(content: .text), text: "")
            }
        }
        
        func turnIntoBulletList() {
            if data.notes[currentIndex].text.hasPrefix("- ") {
                data.notes[currentIndex] = NoteResponse(type: .init(content: .bulletList), text: String(data.notes[currentIndex].text.dropFirst(2)))
            }
        }
        
        func prevIsNotCheckList(_ note: NoteResponse) -> Bool {
            let current = getCurrentIndex(of: note)
            guard current > 0 else { return false }
            
            let previousNote = data.notes[current - 1]
            
            return !((previousNote.type).orEmpty().isContent(of: .list))
        }
        
        func nextIsNotCheckList(_ note: NoteResponse) -> Bool {
            let current = getCurrentIndex(of: note)
            guard current < data.notes.count - 1 else { return false }
            
            let previousNote = data.notes[current + 1]
            
            return !(previousNote.type.orEmpty().isContent(of: .list))
        }
        
        func updateTitle(_ title: String) {
            data.title = title
        }
        
        func updateModifiedDate() {
            if modelContext.hasChanges {
                data.modifiedAt = .now
            }
        }
        
        func saveChanges() {
            do {
                try modelContext.save()
            } catch(let error) {
                print(error)
            }
        }
        
        func sortContent() {
            data.notes.sort { first, second in
                first.createdAt < second.createdAt
            }
        }
    }
}
