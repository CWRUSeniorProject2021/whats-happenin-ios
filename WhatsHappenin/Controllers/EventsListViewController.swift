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
    @Published var events = [Event]()
    var nearbyEventsResource: Resource

    init() {
        nearbyEventsResource = WHAPI.sharedInstance.nearbyEvents
        //nearbyEventsResource.addObserver(self)
        reloadNearbyEvents()
        //whAPI.nearbyEvents(CoordinatePair(latitude: 41.51037, longitude: -81.60557), range: 5.0).addObserver(self).loadIfNeeded()
    }
    
    func reloadNearbyEvents() {
        let coordinates = locationManager.getCurrentLocation() ?? CoordinatePair(latitude: 0.0, longitude: 0.0)
        let range = 5.0
        nearbyEventsResource.withParams([
            "latitude": "\(coordinates.latitude)",
            "longitude": "\(coordinates.longitude)",
            "radius": "\(range)"
        ]).addObserver(self).load()
//        whA
//        whAPI.nearbyEvents(locationManager.getCurrentLocation() ?? CoordinatePair(latitude: 0.0, longitude: 0.0), range: 5.0)
//            .addObserver(self)
//            .loadIfNeeded()
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        print("hit resource changed")
//        var events = resourceo.jsonDict["events"] as? [[String: Any]] ?? []
//        print(events)
        if let result: [Event] = resource.typedContent() {
            print(result)
            self.events = result
        }
    }
}

let eventsListViewController = EventsListViewController()
