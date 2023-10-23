//
//  Color+Default.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

/// This Swift code defines an extension for the SwiftUI `Color` type.
extension Color {
    /// It adds nested enums for monochrome and accent colors, providing a convenient way to access and use color resources.
    
    /// Nested enum for monochrome colors
    enum Monochrome {
        static let black1: Color = .init("Black1")
        static let black2: Color = .init("Black2")
        static let black3: Color = .init("Black3")
        static let gray1: Color = .init("Gray1")
        static let gray2: Color = .init("Gray2")
    }
    
    /// Nested enum for accent colors
    enum Accent {
        /// Primary red color
        static let red1: Color = .init("Red1")
        /// Secondary red color
        static let red2: Color = .init("Red2")
        /// Tertiary red color
        static let red3: Color = .init("Red3")
        
        /// Primary orange color
        static let orange1: Color = .init("Orange1")
        /// Secondary orange color
        static let orange2: Color = .init("Orange2")
        /// Tertiary orange color
        static let orange3: Color = .init("Orange3")
        
        /// Primary green color
        static let green1: Color = .init("Green1")
        /// Secondary green color
        static let green2: Color = .init("Green2")
        /// Tertiary green color
        static let green3: Color = .init("Green3")
        
        /// Primary blue color
        static let blue1: Color = .init("Blue1")
        /// Secondary blue color
        static let blue2: Color = .init("Blue2")
        /// Tertiary blue color
        static let blue3: Color = .init("Blue3")
        
        /// Primary purple color
        static let purple1: Color = .init("Purple1")
        /// Secondary purple color
        static let purple2: Color = .init("Purple2")
        /// Tertiary purple color
        static let purple3: Color = .init("Purple3")
        
        /// Primary pink color
        static let pink1: Color = .init("Pink1")
        /// Secondary pink color
        static let pink2: Color = .init("Pink2")
        /// Tertiary pink color
        static let pink3: Color = .init("Pink3")
    }
}
