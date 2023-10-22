//
//  Note.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI
import SwiftData

/// A class that represents a note file response.
@Model
class NoteFileResponse: Identifiable {

    /// A unique identifier for the note file.
    ///
    /// This attribute is unique and cannot be changed once it is set.
    @Attribute(.unique)
    var id: String = UUID().uuidString

    /// The title of the note file.
    var title: String?

    /// The tags associated with the note file.
    var tags: [TagResponse]?

    /// The notes in the note file.
    var notes: [NoteResponse]

    /// The theme of the note file.
    var theme: String?

    /// The date and time at which the note file was created.
    var createdAt: Date?

    /// The date and time at which the note file was last modified.
    var modifiedAt: Date?

    /// The folder that the note file is in.
    @Relationship(deleteRule: .noAction, inverse: \FolderResponse.notes)
    var folder: FolderResponse?

    /// Initializes a new `NoteFileResponse` object.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the note file.
    ///   - title: The title of the note file.
    ///   - tags: The tags associated with the note file.
    ///   - notes: The notes content in the note file.
    ///   - theme: The theme of the note file.
    ///   - createdAt: The date and time at which the note file was created.
    ///   - modifiedAt: The date and time at which the note file was last modified.
    ///   - folder: The folder that the note file is in.
    init(id: String = UUID().uuidString, title: String? = nil, tags: [TagResponse]? = [], notes: [NoteResponse], theme: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, folder: FolderResponse? = nil) {
        self.id = id
        self.title = title
        self.tags = tags
        self.notes = notes
        self.theme = theme
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.folder = folder
    }
}

/// A class that represents a tag response.
@Model
class TagResponse: Identifiable {

    /// A unique identifier for the tag.
    ///
    /// This attribute is unique and cannot be changed once it is set.
    @Attribute(.unique)
    var id: String = UUID().uuidString

    /// The text of the tag.
    var text: String?

    /// The note file that the tag is associated with.
    @Relationship(deleteRule: .noAction, inverse: \NoteFileResponse.tags)
    var note: NoteFileResponse?

    /// Initializes a new `TagResponse` object.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the tag.
    ///   - text: The text of the tag.
    ///   - note: The note file that the tag is associated with.
    init(id: String = UUID().uuidString, text: String? = nil, note: NoteFileResponse? = nil) {
        self.id = id
        self.text = text
        self.note = note
    }
}


extension NoteFileResponse {
    static let dummy: NoteFileResponse = .init(
        title: "This is Dummy Title",
        notes: [
            NoteResponse(type: .init(content: .text), text: "First sentence here..")
        ],
        theme: ThemeColor.red.rawValue,
        createdAt: .now - 100000,
        modifiedAt: .now - 10000
    )
    
    static let dummy2: NoteFileResponse = .init(
        title: "Before You Go",
        notes: [
//            NoteResponse(type: .init(content: .text), text: "First sentence here..")
        ],
        theme: ThemeColor.orange.rawValue,
        createdAt: .now - 150000,
        modifiedAt: .now - 20000
    )
    
    static let dummy3: NoteFileResponse = .init(
        title: "Art for Life",
        notes: [
            NoteResponse(type: .init(content: .text), text: "First sentence here..")
        ],
        theme: ThemeColor.green.rawValue,
        createdAt: .now - 200000,
        modifiedAt: .now - 30000
    )
    
    static var dummy4: NoteFileResponse = .init(
        title: "Say You Won't Let Go",
        tags: [
            .init(text: "Productivity"),
            .init(text: "Work-Life Balance")
        ],
        notes: [
//            NoteResponse(type: .init(content: .text), text: "First sentence here..")
            .init(type: .init(content: .image), text: "", imageURL: "https://cdn1-production-images-kly.akamaized.net/70a0pk8-1pLXm2bXsSoSWgU7c3Y=/0x0:2012x1134/800x450/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/2762230/original/086593900_1553668873-LISA_BLACKPINK_1.jpg")
        ],
        theme: ThemeColor.blue.rawValue,
        createdAt: .now - 90000,
        modifiedAt: .now - 15000
    )
    
    static let dummy5: NoteFileResponse = .init(
        title: "Love is an Open Door",
        notes: [
            NoteResponse(type: .init(content: .text), text: "First sentence here..")
            
        ],
        theme: ThemeColor.pink.rawValue,
        createdAt: .now - 120000,
        modifiedAt: .now - 17000
    )
    
    static let dummy6: NoteFileResponse = .init(
        title: "Into the Unknown",
        notes: [
//            NoteResponse(type: .init(content: .text), text: "First sentence here..")
        ],
        theme: ThemeColor.purple.rawValue,
        createdAt: .now - 160000,
        modifiedAt: .now - 22000
    )
}
