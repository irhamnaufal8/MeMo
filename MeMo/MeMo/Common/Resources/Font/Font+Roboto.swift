//
//  Font+Roboto.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

extension Font {
    static let robotoTitle1: Font = .custom("Roboto-Bold", size: 24)
    static let robotoTitle2: Font = .custom("Roboto-Bold", size: 21)
    static let robotoTitle3: Font = .custom("Roboto-Bold", size: 18)
    static let robotoHeadline: Font = .custom("Roboto-Medium", size: 14)
    static let robotoBody: Font = .custom("Roboto-Regular", size: 14)
    static let robotoCaption: Font = .custom("Roboto-Regular", size: 12)
    
    static func robotoBold(size: CGFloat) -> Font {
        return .custom("Roboto-Bold", size: size)
    }
    
    static func robotoMedium(size: CGFloat) -> Font {
        return .custom("Roboto-Medium", size: size)
    }
    
    static func robotoRegular(size: CGFloat) -> Font {
        return .custom("Roboto-Regular", size: size)
    }
}
