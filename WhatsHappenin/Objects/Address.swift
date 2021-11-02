//
//  Address.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation

struct Address: Hashable, Codable {
    var street1: String
    var street2: String?
    var city: String
    var postalCode: String
    var state: StateAddress
    var country: Country
    var coordinates: CoordinatePair?
    
    enum CodingKeys: String, CodingKey {
        case street1
        case street2
        case city
        case postalCode = "postal_code"
        case state
        case country
        case coordinates
    }
    
    var stringRepr: String {
        return "\(street1) \(street2 ?? "")\n\(city), \(state.name) \(postalCode)"
    }
}

extension Address: CustomStringConvertible {
    var description: String {
        return "\(street1) \(street2 ?? "") \(city), \(state.name) \(postalCode)"
    }
}
