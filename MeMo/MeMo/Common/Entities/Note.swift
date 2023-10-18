//
//  Note.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct NoteFile: Identifiable {
    var id: UUID = .init()
    var title: String
    var tags: [String]?
    var notes: [any Note]
    var theme: String
    var createdAt: Date?
    var modifiedAt: Date?
}

extension NoteFile {
    static let dummy: NoteFile = .init(
        title: "This is Dummy Title",
        notes: [
            NoteTextContent(text: "First sentence here.."),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "Second sentence lalala. asldkjasd alskdja slkjjlakj alksjdalksjd laksjd alksj alkjlakjsla dlaks laksjd alskdj laksj ads"),
            NoteImageContent(image: .dummy1)
        ],
        theme: ThemeColor.red.rawValue,
        createdAt: .now - 100000,
        modifiedAt: .now - 10000
    )
    
    static let dummy2: NoteFile = .init(
        title: "Before You Go",
        notes: [
            NoteTextContent(text: "I fell by the west side"),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "Like everyone else"),
            NoteImageContent(image: .dummy1)
        ],
        theme: ThemeColor.orange.rawValue,
        createdAt: .now - 150000,
        modifiedAt: .now - 20000
    )
    
    static let dummy3: NoteFile = .init(
        title: "Art for Life",
        notes: [
            NoteTextContent(text: "Welcome to my modern art class!"),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "All we need here is a brush type A"),
            NoteImageContent(image: .dummy1)
        ],
        theme: ThemeColor.green.rawValue,
        createdAt: .now - 200000,
        modifiedAt: .now - 30000
    )
    
    static let dummy4: NoteFile = .init(
        title: "Say You Won't Let Go",
        tags: ["Inspiration", "Music", "Notes", "Draft", "Piano", "In Progress", "Guitar"],
        notes: [
            NoteTextContent(text: "I met you in the dark, you lit me up"),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "You made me feel as though I was enough"),
            NoteTextContent(text: "We danced the night away, we drank too much"),
            
        ],
        theme: ThemeColor.blue.rawValue,
        createdAt: .now - 90000,
        modifiedAt: .now - 15000
    )
    
    static let dummy5: NoteFile = .init(
        title: "Love is an Open Door",
        notes: [
            NoteTextContent(text: "All my life has been a series of doors in my face"),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "And then suddenly I bump into you"),
            NoteTextContent(text: "I was thinking the same thing! 'Cause like"),
            
        ],
        theme: ThemeColor.pink.rawValue,
        createdAt: .now - 120000,
        modifiedAt: .now - 17000
    )
    
    static let dummy6: NoteFile = .init(
        title: "Into the Unknown",
        notes: [
            NoteTextContent(text: "I can hear you, but I won't"),
            NoteImageContent(image: .dummy1),
            NoteTextContent(text: "Some look for trouble"),
            NoteTextContent(text: "While others don't"),
            
        ],
        theme: ThemeColor.purple.rawValue,
        createdAt: .now - 160000,
        modifiedAt: .now - 22000
    )
}
