//
//  Image+Default.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

/// This Swift code defines an extension for the SwiftUI `Image` type.
extension Image {
    /// It adds several static properties to the `Image` type for convenient image initialization.

    /// Static property `dummy1` creates an `Image` instance using the image named "dummy1".
    static let dummy1 = Image("dummy1")

    /// MeMo logo with red color.
    static let logoRed = Image("logo-red")
    
    /// MeMo logo with orange color.
    static let logoOrange = Image("logo-orange")
    
    /// MeMo logo with green color.
    static let logoGreen = Image("logo-green")
    
    /// MeMo logo with blue color.
    static let logoBlue = Image("logo-blue")
    
    /// MeMo logo with purple color.
    static let logoPurple = Image("logo-purple")
    
    /// MeMo logo with pink color.
    static let logoPink = Image("logo-pink")
}
