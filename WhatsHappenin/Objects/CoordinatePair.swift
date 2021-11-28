//
//  CoordinatePair.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation

struct CoordinatePair: Hashable, Codable, Identifiable {
    let id = UUID()
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}


