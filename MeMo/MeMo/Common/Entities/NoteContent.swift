//
//  NoteContent.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI

enum NoteContentType: String {
    case text = "TEXT"
    case image = "IMAGE"
    case list = "LIST"
    case bulletList = "BULLET_LIST"
}

struct NoteResponse: Identifiable, Hashable {
    var id: UUID  = .init()
    var type: String
    var text: String
    var isChecked: Bool = false
    var image: Image?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
