//
//  NoteContent.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI

enum NoteContentType {
    case text
    case image
    case list
    case bulletList
}

protocol Note: Identifiable {
    var id: UUID { get set }
    var type: NoteContentType { get }
    var text: String { get set }
    var isChecked: Bool { get set }
}

struct NoteTextContent: Note {
    var id: UUID = .init()
    let type: NoteContentType = .text
    var text: String
    var isChecked: Bool = false
}

struct NoteImageContent: Note {
    var id: UUID = .init()
    let type: NoteContentType = .image
    var text: String
    var image: Image
    var isChecked: Bool = false
}

struct NoteListContent: Note {
    var id: UUID = .init()
    let type: NoteContentType = .list
    var text: String
    var isChecked: Bool = false
}

struct NoteBulletListContent: Note {
    var id: UUID = .init()
    let type: NoteContentType = .bulletList
    var text: String
    var isChecked: Bool = false
}
