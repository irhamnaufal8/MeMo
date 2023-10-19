//
//  NoteViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI
import PhotosUI

final class NoteViewModel: ObservableObject {
    @Published var data: NoteFile
    
    @Published var currentIndex = 0
    
    @Published var isShowTagSheet = false
    @Published var newTag = ""
    @Published var isShowModified = true
    
    @Published var isShowColorPicker = false
    @Published var isShowBottomBar = false
    @Published var isEditTitle = false
    
    @Published var isShowPhotoPicker = false
    @Published var selectedImage: PhotosPickerItem? = nil
    
    @Published var themes: [ThemeColor] = [.red, .orange, .green, .blue, .purple, .pink]
    var currentTheme: String {
        get { data.theme }
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
            return tags.joined(separator: ", ")
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
        let modifiedDate = formatter.string(from: data.createdAt.orCurrentDate())
        
        return isShowModified ? "Last Modified at \(modifiedDate)" : "Created at \(createdDate)"
    }
    
    init(data: NoteFile) {
        self.data = data
    }
    
    func deleteTag(_ tag: String) {
        withAnimation {
            data.tags?.removeAll(where: { $0 == tag })
        }
    }
    
    func addNewTag() {
        if !newTag.isEmpty {
            withAnimation {
                if let _ = data.tags {
                    data.tags?.append(newTag)
                } else {
                    data.tags = []
                    data.tags?.append(newTag)
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
    
    func getCurrentIndex(of note: any Note) -> Int {
        return data.notes.firstIndex(where: { $0.id == note.id }) ?? currentIndex
    }
    
    func addNoteText(after note: any Note) {
        let noteText = NoteTextContent(text: "")
        withAnimation {
            data.notes.insert(noteText, at: currentIndex + 1)
        }
    }
    
    func addNoteTextOnLast() {
        guard data.notes.last is NoteImageContent else { return }
        let noteText = NoteTextContent(text: "")
        withAnimation {
            data.notes.append(noteText)
        }
    }
    
    func addNoteImage(with photo: PhotosPickerItem?) async {
        if let data = try? await photo?.loadTransferable(type: Data.self) {
            if let uiImage = UIImage(data: data) {
                let noteImage = NoteImageContent(text: "", image: Image(uiImage: uiImage))
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
        let noteList = NoteListContent(text: data.notes[currentIndex].text)
        withAnimation {
            data.notes[currentIndex] = noteList
        }
    }
    
    func addNextNoteList() {
        let noteList = NoteListContent(text: "")
        withAnimation {
            data.notes.insert(noteList, at: currentIndex+1)
        }
    }
    
    func addNextBulletList(after note: NoteBulletListContent) {
        let bulletList = NoteBulletListContent(text: "")
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
        guard currentIndex > 0 else { return }
        if isEmpty {
            data.notes.remove(at: currentIndex)
        }
    }
    
    func deleteNoteImage(_ image: NoteImageContent) {
        currentIndex = getCurrentIndex(of: image)
        turnIntoText(if: true)
    }
    
    func turnIntoText(if isEmpty: Bool) {
        if isEmpty {
            data.notes[currentIndex] = NoteTextContent(text: "")
        }
    }
    
    func turnIntoBulletList() {
        if data.notes[currentIndex].text.hasPrefix("- ") {
            data.notes[currentIndex] = NoteBulletListContent(text: String(data.notes[currentIndex].text.dropFirst(2)))
        }
    }
    
    func prevIsNotCheckList(_ note: any Note) -> Bool {
        let current = getCurrentIndex(of: note)
        guard current < data.notes.count - 1 else { return false }
        return !(data.notes[current - 1] is NoteListContent)
    }
    
    func nextIsNotCheckList(_ note: any Note) -> Bool {
        let current = getCurrentIndex(of: note)
        guard current < data.notes.count - 1 else { return false }
        return !(data.notes[current + 1] is NoteListContent)
    }
}
