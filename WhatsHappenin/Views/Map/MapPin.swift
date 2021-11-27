//
//  MapPin.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/26/21.
//

import SwiftUI
import MapKit

struct IdentifiablePlace: Identifiable {
    let id: Int
    let location: CLLocationCoordinate2D
    
    init(id: Int, coords: CoordinatePair) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: coords.latitude,
            longitude: coords.longitude)
    }
}
