//
//  UserCreatedEventsController.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 11/1/21.
//
import Foundation
import Siesta
import CoreLocation

class UserCreatedEventsController: ObservableObject, ResourceObserver {
    @Published var events = [Event]()
    var createdEventsResource: Resource

    init() {
        createdEventsResource = WHAPI.sharedInstance.createdEvents
        //nearbyEventsResource.addObserver(self)
        reloadCreatedEvents()
        //whAPI.nearbyEvents(CoordinatePair(latitude: 41.51037, longitude: -81.60557), range: 5.0).addObserver(self).loadIfNeeded()
    }
    
    func reloadCreatedEvents() {
        createdEventsResource.addObserver(self).loadIfNeeded()
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

let userCreatedEventsController = UserCreatedEventsController()
