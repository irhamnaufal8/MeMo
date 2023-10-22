//
//  TagResponse.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import Foundation

/// A model that represents a tag response.
struct TagResponse: Identifiable {
    /// A unique identifier for the tag.
    var id: String = UUID().uuidString

    /// The text of the tag.
    var text: String?

    /// The note file that the tag is associated with.
    var note: NoteFile?
}
