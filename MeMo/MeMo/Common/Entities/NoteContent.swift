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
}

protocol Note: Identifiable {
    var id: UUID { get set }
    var type: NoteContentType { get }
}

struct NoteTextContent: Note {
    var id: UUID = .init()
    let type: NoteContentType = .text
    var text: String
}

struct NoteImageContent: Note {
    var id: UUID = .init()
    let type: NoteContentType = .image
    var image: Image
}

struct NoteListContent: Note {
    var id: UUID = .init()
    let type: NoteContentType = .list
    var list: [NoteList]
}

struct NoteList: Identifiable {
    var id: UUID = .init()
    var isChecked: Bool = false
    var text: String
}
