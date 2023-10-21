//
//  String+content.swift
//  MeMo
//
//  Created by Irham Naufal on 20/10/23.
//

import Foundation

extension String {
    /// Initializes a new string from a note content type.
    init(content: NoteContentType) {
        self = content.rawValue
    }
    
    /// Returns `true` if the string is the raw value of the given note content type, and `false` otherwise.
    func isContent(of content: NoteContentType) -> Bool {
        self == content.rawValue
    }
}
