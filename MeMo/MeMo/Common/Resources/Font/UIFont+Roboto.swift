//
//  UIFont+Roboto.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import UIKit

extension UIFont {
    static let robotoTitle1 = UIFont(name: "Roboto-Bold", size: 24)
    static let robotoTitle2 = UIFont(name: "Roboto-Bold", size: 21)
    static let robotoTitle3 = UIFont(name: "Roboto-Bold", size: 18)
    static let robotoHeadline = UIFont(name: "Roboto-Medium", size: 16)
    static let robotoBody = UIFont(name: "Roboto-Regular", size: 16)
    static let robotoCaption = UIFont(name: "Roboto-Regular", size: 14)
    
    static func robotoBold(size: CGFloat) -> UIFont? {
        return .init(name: "Roboto-Bold", size: size)
    }
    
    static func robotoMedium(size: CGFloat) -> UIFont? {
        return .init(name: "Roboto-Medium", size: size)
    }
    
    static func robotoRegular(size: CGFloat) -> UIFont? {
        return .init(name: "Roboto-Regular", size: size)
    }
}
