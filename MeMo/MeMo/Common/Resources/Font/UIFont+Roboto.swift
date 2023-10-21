//
//  UIFont+Roboto.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import UIKit

/// This Swift code defines an extension for the UIKit `UIFont` type.
extension UIFont {
    /// It adds several static properties and methods to the `Font` type for convenient font creation.

    /// Static properties that define roboto bold for Title 1 type.
    static let robotoTitle1 = UIFont(name: "Roboto-Bold", size: 24)
    
    /// Static properties that define roboto bold for Title 2 type.
    static let robotoTitle2 = UIFont(name: "Roboto-Bold", size: 21)
    
    /// Static properties that define roboto bold for Title 3 type.
    static let robotoTitle3 = UIFont(name: "Roboto-Bold", size: 18)
    
    /// Static properties that define roboto medium for headline type.
    static let robotoHeadline = UIFont(name: "Roboto-Medium", size: 16)
    
    /// Static properties that define roboto regular for Body type.
    static let robotoBody = UIFont(name: "Roboto-Regular", size: 16)
    
    /// Static properties that define roboto regular for caption type.
    static let robotoCaption = UIFont(name: "Roboto-Regular", size: 14)
    
    /// Static methods for creating custom fonts with bold styles and custom size.
    static func robotoBold(size: CGFloat) -> UIFont? {
        return .init(name: "Roboto-Bold", size: size)
    }
    
    /// Static methods for creating custom fonts with medium styles and custom size.
    static func robotoMedium(size: CGFloat) -> UIFont? {
        return .init(name: "Roboto-Medium", size: size)
    }
    
    /// Static methods for creating custom fonts with regular styles and custom size.
    static func robotoRegular(size: CGFloat) -> UIFont? {
        return .init(name: "Roboto-Regular", size: size)
    }
}
