//
//  Note.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct NoteFile: Identifiable {
    var id: UUID = .init()
    var title: String
    var image: String
    var notes: [any Note]
    var theme: String
    var createdAt: Date?
    var modifiedAt: Date?
}

extension NoteFile {
    static let dummy: NoteFile = .init(
        title: "This is Dummy Title",
        image: "🎮",
        notes: [
            NoteTextContent(text: "First sentence here.."),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "Second sentence lalala. asldkjasd alskdja slkjjlakj alksjdalksjd laksjd alksj alkjlakjsla dlaks laksjd alskdj laksj ads"),
            NoteImageContent(image: .dummy1)
        ],
        theme: ThemeColor.red.rawValue,
        createdAt: .now - 100000,
        modifiedAt: .now - 10000
    )
    
    static let dummy2: NoteFile = .init(
        title: "Before You Go",
        image: "💌",
        notes: [
            NoteTextContent(text: "I fell by the west side"),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "Like everyone else"),
            NoteImageContent(image: .dummy1)
        ],
        theme: ThemeColor.orange.rawValue,
        createdAt: .now - 150000,
        modifiedAt: .now - 20000
    )
    
    static let dummy3: NoteFile = .init(
        title: "Art for Life",
        image: "🎨",
        notes: [
            NoteTextContent(text: "Welcome to my modern art class!"),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "All we need here is a brush type A"),
            NoteImageContent(image: .dummy1)
        ],
        theme: ThemeColor.green.rawValue,
        createdAt: .now - 200000,
        modifiedAt: .now - 30000
    )
}
