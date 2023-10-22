//
//  NoteContentResponse.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import Foundation

/// A model that represents a note response.
struct NoteContentResponse: Identifiable {
    /// A unique identifier for the note content.
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
    var noteFile: NoteFile?

    /// The date and time at which the content was created.
    var createdAt: Date
}
