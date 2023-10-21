//
//  NoteContent.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI
import SwiftData

enum NoteContentType: String {
    case text = "TEXT"
    case image = "IMAGE"
    case list = "LIST"
    case bulletList = "BULLET_LIST"
}

@Model
class NoteResponse: Identifiable {
    @Attribute(.unique)
    var id: String = UUID().uuidString
    var type: String?
    var text: String
    var isChecked: Bool? = false
    var imageURL: String?
    var image: Data?
    
    @Relationship(deleteRule: .cascade, inverse: \NoteFileResponse.notes)
    var noteFile: NoteFileResponse?
    var createdAt: Date
    
    init(id: String = UUID().uuidString, type: String? = nil, text: String, isChecked: Bool? = false, imageURL: String? = nil, image: Data? = nil, noteFile: NoteFileResponse? = nil, createdAt: Date = .now) {
        self.id = id
        self.type = type
        self.text = text
        self.isChecked = isChecked
        self.imageURL = imageURL
        self.image = image
        self.noteFile = noteFile
        self.createdAt = createdAt
    }
}
