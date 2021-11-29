//
//  CoordinatePair.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation
import CoreLocation

struct CoordinatePair: Hashable, Codable, Identifiable {
    let id = UUID()
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    func toCLLocationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


