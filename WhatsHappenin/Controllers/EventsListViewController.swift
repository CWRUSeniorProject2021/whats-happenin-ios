//
//  EventsListViewController.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation
import Siesta
import CoreLocation
import UIKit

class EventsListViewController: ObservableObject, ResourceObserver {
    static let sharedInstance = EventsListViewController()
    
    @Published var nearbyEvents = [Event]()
    @Published var yourEvents = [Event]()
    @Published var feedEvents = [Event]()
    @Published var eventImages = [Event:UIImage]()
    
    var nearbyEventsResource: Resource

    init() {
        nearbyEventsResource = WHAPI.sharedInstance.nearbyEvents
        loadNearbyEvents()
    }
    
    func loadNearbyEvents() {
        let coordinates = locationManager.getCurrentLocation() ?? CoordinatePair(latitude: 0.0, longitude: 0.0)
        let range = 5.0
        nearbyEventsResource = WHAPI.sharedInstance.nearbyEvents.withParams([
            "latitude": "\(coordinates.latitude)",
            "longitude": "\(coordinates.longitude)",
            "radius": "\(range)"
        ])
        nearbyEventsResource.addObserver(self).load()
    }
    
    func reloadNearbyEvents() async {
        loadNearbyEvents()
        while(nearbyEventsResource.isLoading) {
            print("waiting")
        }
    }
    
    func loadImages(events: [Event]) {
        events.forEach({ event in
            if let url: String = event.imageURL {
                let resource = WHAPI.sharedInstance.resource(absoluteURL: url)
                if let request = resource.loadIfNeeded() {
                //resource.loadIfNeeded()
                    request
                    .onSuccess { response in
                        print(response)
                        print("image loaded")
                        if let img: UIImage = response.typedContent() {
                            self.eventImages[event] = img
                        }
                    }
                    .onFailure { response in
                        print("image failed")
                    }
                }
            }
        })
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        switch (resource) {
        // Handle nearby
        case nearbyEventsResource:
            if let result: [Event] = resource.typedContent() {
                self.nearbyEvents = result
                self.loadImages(events: self.nearbyEvents)
            }
        default:
            break
        }
        
    }
}
