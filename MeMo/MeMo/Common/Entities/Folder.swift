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
    var icon: String?
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
        notes: [.dummy, .dummy2, .dummy3],
        createdAt: .now - 100000,
        modifiedAt: .now - 50000
    )
}
