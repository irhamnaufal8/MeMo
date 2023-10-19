//
//  Folder.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import Foundation

struct Folder: Identifiable {
    var id: UUID = .init()
    var title: String
    var icon: String
    var theme: String?
    var notes: [NoteFile]
    var createdAt: Date
    var modifiedAt: Date
}

extension Folder {
    static let dummy: Folder = .init(
        title: "Code Tutorial",
        icon: "🏆",
        theme: ThemeColor.purple.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 100000,
        modifiedAt: .now - 50000
    )
    
    static let dummy2: Folder = .init(
        title: "Our Love Story",
        icon: "💌",
        theme: ThemeColor.red.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 120000,
        modifiedAt: .now - 60000
    )
    
    static let dummy3: Folder = .init(
        title: "Study Study Study!",
        icon: "📚",
        theme: ThemeColor.orange.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 140000,
        modifiedAt: .now - 70000
    )
    
    static let dummy4: Folder = .init(
        title: "Game Sess",
        icon: "🎮",
        theme: ThemeColor.blue.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 200000,
        modifiedAt: .now - 100000
    )
    
    static let dummy5: Folder = .init(
        title: "Friday Movie",
        icon: "🎬",
        theme: ThemeColor.pink.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 160000,
        modifiedAt: .now - 80000
    )
    
    static let dummy6: Folder = .init(
        title: "Relaxing Music",
        icon: "🎹",
        theme: ThemeColor.blue.rawValue,
        notes: [.dummy, .dummy2, .dummy3, .dummy4, .dummy5, .dummy6],
        createdAt: .now - 110000,
        modifiedAt: .now - 23000
    )
}
