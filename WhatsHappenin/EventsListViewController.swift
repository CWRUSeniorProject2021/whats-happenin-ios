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

    init() {
        reloadNearbyEvents()
        //whAPI.nearbyEvents(CoordinatePair(latitude: 41.51037, longitude: -81.60557), range: 5.0).addObserver(self).loadIfNeeded()
    }
    
    func reloadNearbyEvents() {
        whAPI.nearbyEvents(locationManager.getCurrentLocation() ?? CoordinatePair(latitude: 0.0, longitude: 0.0), range: 5.0)
            .addObserver(self)
            .loadIfNeeded()
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        print("hit resource changed")
//        var events = resourceo.jsonDict["events"] as? [[String: Any]] ?? []
//        print(events)
        if let result: [Event] = resource.typedContent() {
            print("hi")
            print(result)
            self.events = result
        }
    }
}

let eventsListViewController = EventsListViewController()
