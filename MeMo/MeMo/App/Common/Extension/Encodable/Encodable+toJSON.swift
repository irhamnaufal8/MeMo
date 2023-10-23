//
//  Encodable+toJSON.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import Foundation

/// An extension to the `Encodable` protocol that adds `toJSON()` and `toJSONData()` methods.
extension Encodable {
    /// Encodes the object to a JSON dictionary.
    ///
    /// - Returns: A JSON dictionary representing the object, or an empty dictionary if the object cannot be encoded.
    func toJSON() -> [String: Any] {
        guard let data =  try? JSONEncoder().encode(self),
                    let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                    let json = dictionary as? [String: Any] else {
            return [:]
        }
        
        return json
    }

    /// Encodes the object to a JSON data object.
    ///
    /// - Returns: A JSON data object representing the object, or an empty data object if the object cannot be encoded.
    func toJSONData() -> Data {
        guard let data =  try? JSONEncoder().encode(self) else {
            return Data()
        }
        
        return data
    }
}
