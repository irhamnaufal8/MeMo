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
}

extension NoteFile {
    static let dummy: NoteFile = .init(
        title: "This is Dummy Title",
        image: "🎮",
        notes: [
            NoteTextContent(text: "First sentence here.."),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "\n"),
            NoteTextContent(text: "Second sentence lalala. asldkjasd alskdja slkjjlakj alksjdalksjd laksjd alksj alkjlakjsla dlaks laksjd alskdj laksj ads"),
            NoteImageContent(image: .dummy1)
        ],
        theme: ThemeColor.red.rawValue
    )
    
    static let dummy2: NoteFile = .init(
        title: "Shopping List",
        image: "🍽️",
        notes: [
            NoteListContent(list: [
                .init(isChecked: false, text: "Pencil"),
                .init(isChecked: false, text: "Soap"),
                .init(isChecked: false, text: "Shampoo"),
                .init(isChecked: false, text: "Red T-Shirt"),
                .init(isChecked: false, text: "Tomato"),
            ])
        ],
        theme: ThemeColor.purple.rawValue
    )
}
