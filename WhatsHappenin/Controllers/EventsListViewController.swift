//
//  EventsListViewController.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation
import Siesta
import CoreLocation

class EventsListViewController: ObservableObject, ResourceObserver {
    static let sharedInstance = EventsListViewController()
    
    @Published var nearbyEvents = [Event]()
    @Published var yourEvents = [Event]()
    @Published var feedEvents = [Event]()
    
    var nearbyEventsResource: Resource

    init() {
        nearbyEventsResource = WHAPI.sharedInstance.nearbyEvents
        reloadNearbyEvents()
    }
    
    func reloadNearbyEvents() {
        let coordinates = locationManager.getCurrentLocation() ?? CoordinatePair(latitude: 0.0, longitude: 0.0)
        let range = 5.0
        nearbyEventsResource = WHAPI.sharedInstance.nearbyEvents.withParams([
            "latitude": "\(coordinates.latitude)",
            "longitude": "\(coordinates.longitude)",
            "radius": "\(range)"
        ])
        nearbyEventsResource.addObserver(self).load()
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        switch (resource) {
        // Handle nearby
        case nearbyEventsResource:
            if let result: [Event] = resource.typedContent() {
                self.nearbyEvents = result
            }
        default:
            break
        }
        
    }
}
