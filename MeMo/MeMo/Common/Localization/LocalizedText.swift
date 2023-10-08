//
//  LocalizedText.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

enum LocalizedText {
    static let helloWorld = NSLocalizedString(
        "Hello, world",
        value: "Hello, world",
        comment: ""
    )
    
    static func withValue(value: String) -> String {
        String(
            format: NSLocalizedString(
                "With Value",
                comment: ""
            ),
            value
        )
    }
}
