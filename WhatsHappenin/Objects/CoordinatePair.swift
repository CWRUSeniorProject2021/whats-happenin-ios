//
//  CoordinatePair.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation

struct CoordinatePair: Hashable, Codable {
    var latitude: Float
    var longitude: Float
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
