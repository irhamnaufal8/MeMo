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

struct NoteResponse: Identifiable, Hashable, Codable {
    var id: String? = UUID().uuidString
    var type: String?
    var text: String
    var isChecked: Bool? = false
    var imageURL: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
