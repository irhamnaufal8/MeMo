//
//  Note.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct NoteFileResponse: Identifiable {
    var id: UUID = .init()
    var title: String
    var tags: [String]?
    var notes: [NoteResponse]
    var theme: String
    var createdAt: Date?
    var modifiedAt: Date?
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
        tags: ["Inspiration", "Music", "Notes", "Draft", "Piano", "In Progress", "Guitar"],
        notes: [
//            NoteResponse(type: .init(content: .text), text: "First sentence here..")
            
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
