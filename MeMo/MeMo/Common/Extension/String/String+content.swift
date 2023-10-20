//
//  String+content.swift
//  MeMo
//
//  Created by Irham Naufal on 20/10/23.
//

import Foundation

extension String {
    init(content: NoteContentType) {
        self = content.rawValue
    }
    
    func isContent(of content: NoteContentType) -> Bool {
        self == content.rawValue
    }
}
