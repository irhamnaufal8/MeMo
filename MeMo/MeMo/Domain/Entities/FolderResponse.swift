//
//  FolderResponse.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import Foundation

/// A model that represents a folder response.
struct FolderResponse: Identifiable {
    /// A unique identifier for the folder.
    var id: String = UUID().uuidString

    /// The title of the folder.
    var title: String?

    /// The icon of the folder.
    var icon: String?

    /// The theme of the folder.
    var theme: String?

    /// The notes in the folder.
    var notes: [NoteFileResponse]

    /// The date and time at which the folder was created.
    var createdAt: Date?

    /// The date and time at which the folder was last modified.
    var modifiedAt: Date?
}
