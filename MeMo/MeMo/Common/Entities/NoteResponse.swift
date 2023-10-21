//
//  Note.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI
import SwiftData

@Model
class NoteFileResponse: Identifiable {
    
    @Attribute(.unique)
    var id: String = UUID().uuidString
    var title: String?
    var tags: [TagResponse]?
    var notes: [NoteResponse]
    var theme: String?
    var createdAt: Date?
    var modifiedAt: Date?
    
    @Relationship(deleteRule: .noAction, inverse: \FolderResponse.notes)
    var folder: FolderResponse?
    
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

@Model
class TagResponse: Identifiable {
    @Attribute(.unique)
    var id: String = UUID().uuidString
    var text: String?
    
    @Relationship(deleteRule: .noAction, inverse: \NoteFileResponse.tags)
    var note: NoteFileResponse?
    
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
