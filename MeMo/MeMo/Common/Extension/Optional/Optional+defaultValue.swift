//
//  Optional+defaultValue.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import Foundation

extension Optional where Wrapped == String {
    func orEmpty() -> String {
        return self ?? ""
    }
}

extension Optional where Wrapped == Int {
    func orZero() -> Int {
        return self ?? 0
    }
}

extension Optional where Wrapped == Double {
    func orZero() -> Double {
        return self ?? 0.0
    }
}

extension Optional where Wrapped == Date {
    func orCurrentDate() -> Date {
        return self ?? Date()
    }
}
