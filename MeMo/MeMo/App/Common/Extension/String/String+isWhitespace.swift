//
//  String+isWhitespace.swift
//  MeMo
//
//  Created by Irham Naufal on 19/10/23.
//

import Foundation

extension String {
    /// Returns `true` if the string is empty or contains only whitespace characters, and `false` otherwise.
    var isWhitespace: Bool {
        guard let array = self.compactMap({ $0 }) as? [Character] else { return false }
        return array.allSatisfy { $0.isWhitespace }
    }
}
