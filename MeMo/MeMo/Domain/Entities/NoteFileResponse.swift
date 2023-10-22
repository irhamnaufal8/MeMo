//
//  NoteFileResponse.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import Foundation

struct NoteFileResponse: Identifiable {
    /// A unique identifier for the note file.
    var id: String = UUID().uuidString

    /// The title of the note file.
    var title: String?

    /// The tags associated with the note file.
    var tags: [Tag]?

    /// The notes in the note file.
    var notes: [NoteContent]

    /// The theme of the note file.
    var theme: String?

    /// The date and time at which the note file was created.
    var createdAt: Date? = .now

    /// The date and time at which the note file was last modified.
    var modifiedAt: Date? = .now

    /// The folder that the note file is in.
    var folder: Folder?
}
