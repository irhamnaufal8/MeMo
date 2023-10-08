//
//  Encodable+toJSON.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import Foundation

extension Encodable {
    func toJSON() -> [String: Any] {
        guard let data =  try? JSONEncoder().encode(self),
                    let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                    let json = dictionary as? [String: Any] else {
            return [:]
        }
        
        return json
    }
    
    func toJSONData() -> Data {
        guard let data =  try? JSONEncoder().encode(self) else {
            return Data()
        }
        
        return data
    }
}
