//
//  EventsListViewController.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation
import Siesta

class EventsListViewController: ObservableObject, ResourceObserver {
    @Published var events = [Event]()

    init() {
        whAPI.nearbyEvents(CoordinatePair(latitude: 41.51037, longitude: -81.60557), range: 5.0).addObserver(self).loadIfNeeded()
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        print("hit resource changed")
        if let loadedEvents: [Event] = resource.typedContent() {
            print(loadedEvents)
            self.events = loadedEvents
        }
    }
}
