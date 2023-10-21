//
//  Folder.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import Foundation
import SwiftData

/// A class that represents a folder response.
@Model
class FolderResponse: Identifiable {

    /// A unique identifier for the folder.
    ///
    /// This attribute is unique and cannot be changed once it is set.
    @Attribute(.unique)
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

    /// Initializes a new `FolderResponse` object.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the folder.
    ///   - title: The title of the folder.
    ///   - icon: The icon of the folder.
    ///   - theme: The theme of the folder.
    ///   - notes: The notes in the folder.
    ///   - createdAt: The date and time at which the folder was created.
    ///   - modifiedAt: The date and time at which the folder was last modified.
    init(id: String = UUID().uuidString, title: String? = nil, icon: String? = nil, theme: String? = nil, notes: [NoteFileResponse] = [], createdAt: Date? = nil, modifiedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.theme = theme
        self.notes = notes
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}


extension FolderResponse {
    /// A dummy data of `FolderResponse`
    static let dummy: FolderResponse = .init(
        title: "Code Tutorial",
        icon: "🏆",
        theme: ThemeColor.purple.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 100000,
        modifiedAt: .now - 50000
    )
    
    /// A dummy data of `FolderResponse`
    static let dummy2: FolderResponse = .init(
        title: "Our Love Story",
        icon: "💌",
        theme: ThemeColor.red.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 120000,
        modifiedAt: .now - 60000
    )
    
    /// A dummy data of `FolderResponse`
    static let dummy3: FolderResponse = .init(
        title: "Study Study Study!",
        icon: "📚",
        theme: ThemeColor.orange.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 140000,
        modifiedAt: .now - 70000
    )
    
    /// A dummy data of `FolderResponse`
    static let dummy4: FolderResponse = .init(
        title: "Game Sess",
        icon: "🎮",
        theme: ThemeColor.blue.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 200000,
        modifiedAt: .now - 100000
    )
    
    /// A dummy data of `FolderResponse`
    static let dummy5: FolderResponse = .init(
        title: "Friday Movie",
        icon: "🎬",
        theme: ThemeColor.pink.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 160000,
        modifiedAt: .now - 80000
    )
    
    /// A dummy data of `FolderResponse`
    static let dummy6: FolderResponse = .init(
        title: "Relaxing Music",
        icon: "🎹",
        theme: ThemeColor.blue.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 110000,
        modifiedAt: .now - 23000
    )
}
