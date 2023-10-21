//
//  NoteContent.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI
import SwiftData

/// An enum that represents different types of note content.
enum NoteContentType: String {
    /// Text content.
    case text = "TEXT"
    /// Image content.
    case image = "IMAGE"
    /// List content.
    case list = "LIST"
    /// Bullet list content.
    case bulletList = "BULLET_LIST"
}

/// A class that represents a note response.
@Model
class NoteResponse: Identifiable {

    /// A unique identifier for the note.
    ///
    /// This attribute is unique and cannot be changed once it is set.
    @Attribute(.unique)
    var id: String = UUID().uuidString

    /// The type of the note content.
    var type: String?

    /// The text content of the note.
    var text: String

    /// Whether or not the note is checked.
    var isChecked: Bool? = false

    /// The URL of the note's image.
    var imageURL: String?

    /// The data of the note's image.
    var image: Data?

    /// The note file that the note is in.
    var noteFile: NoteFileResponse?

    /// The date and time at which the note was created.
    var createdAt: Date

    /// Initializes a new `NoteResponse` object.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the note.
    ///   - type: The type of the note content.
    ///   - text: The text content of the note.
    ///   - isChecked: Whether or not the note is checked.
    ///   - imageURL: The URL of the note's image.
    ///   - image: The data of the note's image.
    ///   - noteFile: The note file that the note is in.
    ///   - createdAt: The date and time at which the note was created.
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

