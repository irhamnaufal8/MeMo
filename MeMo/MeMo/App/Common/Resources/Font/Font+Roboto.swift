//
//  Font+Roboto.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

/// This Swift code defines an extension for the SwiftUI `Font` type.
extension Font {
    /// It adds several static properties and methods to the `Font` type for convenient font creation.

    /// Static properties that define roboto bold for Title 1 type.
    static let robotoTitle1: Font = .custom("Roboto-Bold", size: 24)
    
    /// Static properties that define roboto bold for Title 2 type.
    static let robotoTitle2: Font = .custom("Roboto-Bold", size: 21)
    
    /// Static properties that define roboto bold for Title 3 type.
    static let robotoTitle3: Font = .custom("Roboto-Bold", size: 18)
    
    /// Static properties that define roboto medium for headline type.
    static let robotoHeadline: Font = .custom("Roboto-Medium", size: 14)
    
    /// Static properties that define roboto regular for Body type.
    static let robotoBody: Font = .custom("Roboto-Regular", size: 14)
    
    /// Static properties that define roboto regular for caption type.
    static let robotoCaption: Font = .custom("Roboto-Regular", size: 12)

    /// Static methods for creating custom fonts with bold styles and custom size.
    static func robotoBold(size: CGFloat) -> Font {
        return .custom("Roboto-Bold", size: size)
    }
    
    /// Static methods for creating custom fonts with medium styles and custom size.
    static func robotoMedium(size: CGFloat) -> Font {
        return .custom("Roboto-Medium", size: size)
    }

    /// Static methods for creating custom fonts with regular styles and custom size.
    static func robotoRegular(size: CGFloat) -> Font {
        return .custom("Roboto-Regular", size: size)
    }
}
