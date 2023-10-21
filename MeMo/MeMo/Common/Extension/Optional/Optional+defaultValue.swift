//
//  Optional+defaultValue.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import Foundation

/// An extension to the `Optional` type where `Wrapped` is `String` that adds an `orEmpty()` method.
extension Optional where Wrapped == String {
    /// Returns the value of the optional, or an empty string if the optional is `nil`.
    func orEmpty() -> String {
        return self ?? ""
    }
}

/// An extension to the `Optional` type where `Wrapped` is `Int` that adds an `orZero()` method.
extension Optional where Wrapped == Int {
    /// Returns the value of the optional, or 0 if the optional is `nil`.
    func orZero() -> Int {
        return self ?? 0
    }
}

/// An extension to the `Optional` type where `Wrapped` is `Double` that adds an `orZero()` method.
extension Optional where Wrapped == Double {
    /// Returns the value of the optional, or 0.0 if the optional is `nil`.
    func orZero() -> Double {
        return self ?? 0.0
    }
}

/// An extension to the `Optional` type where `Wrapped` is `Date` that adds an `orCurrentDate()` method.
extension Optional where Wrapped == Date {
    /// Returns the value of the optional, or the current date if the optional is `nil`.
    func orCurrentDate() -> Date {
        return self ?? Date()
    }
}

/// An extension to the `Optional` type where `Wrapped` is `Bool` that adds an `orFalse()` method.
public extension Optional where Wrapped == Bool {
    /// Returns the value of the optional, or `false` if the optional is `nil`.
    func orFalse() -> Bool {
        return self ?? false
    }
}

