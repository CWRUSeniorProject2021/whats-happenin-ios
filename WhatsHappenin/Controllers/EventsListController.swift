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

class EventsListController: ObservableObject, ResourceObserver {
    static let sharedInstance = EventsListController()
    
    @Published var events = [Int:Event]()
    @Published var nearbyEventIds = [Int]()
    @Published var yourEventIds = [Int]()
    @Published var feedEventIds = [Int]()
    @Published var upcomingEventIds = [Int]()
    @Published var pastEventIds = [Int]()
    @Published var eventImages = [Event:UIImage]()
    
    private var eventResources = [Resource]()
    private var nearbyEventsResource: Resource

    init() {
        nearbyEventsResource = WHAPI.sharedInstance.nearbyEvents
        loadNearbyEvents()
        
        WHAPI.sharedInstance.yourEvents.addObserver(self)
        WHAPI.sharedInstance.upcomingEvents.addObserver(self)
        WHAPI.sharedInstance.pastEvents.addObserver(self)
        loadYourEvents()
        
        WHAPI.sharedInstance.events.addObserver(self)
    }
    
    var nearbyEvents: [Event] {
        get { return getEvents(nearbyEventIds) }
        set(val) {
          nearbyEventIds = refreshEvents(val)
        }
    }
    var yourEvents: [Event] {
        get { return getEvents(yourEventIds) }
        set(val) {
          yourEventIds = refreshEvents(val)
        }
    }
    var feedEvents: [Event] {
        get { return getEvents(feedEventIds) }
        set(val) {
          feedEventIds = refreshEvents(val)
        }
    }
    var upcomingEvents: [Event] {
        get { return getEvents(upcomingEventIds) }
        set(val) {
          upcomingEventIds = refreshEvents(val)
        }
    }
    var pastEvents: [Event] {
        get { return getEvents(pastEventIds) }
        set(val) {
          pastEventIds = refreshEvents(val)
        }
    }
    
    func getEvents(_ arr: [Int]) -> [Event] {
        var temp = [Event]()
        arr.forEach( { id in
            if let event = events[id] {
                temp.append(event)
            } else {
            }
        })
        return temp
    }
    
    // MARK: Load events
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
    
    func loadYourEvents() {
        WHAPI.sharedInstance.yourEvents.load()
        WHAPI.sharedInstance.pastEvents.load()
        WHAPI.sharedInstance.upcomingEvents.load()
    }
    
    // MARK: Load Images
    func loadImage(_ event: Event) {
        if (self.eventImages[event] != nil) {
            return
        }

        if let url: String = event.imageURL {
            let resource = WHAPI.sharedInstance.resource(absoluteURL: url)
            if let request = resource.loadIfNeeded() {
                request
                .onSuccess { response in
                    if let img: UIImage = response.typedContent() {
                        self.eventImages[event] = img
                    }
                }
                .onFailure { response in
                }
            }
        }
    }
    
    func loadImages(_ events: [Event]) {
        events.forEach({ event in
            if let url: String = event.imageURL {
                let resource = WHAPI.sharedInstance.resource(absoluteURL: url)
                if let request = resource.loadIfNeeded() {
                    request
                    .onSuccess { response in
                        print(response)
                        if let img: UIImage = response.typedContent() {
                            self.eventImages[event] = img
                        }
                    }
                    .onFailure { response in
                    }
                }
            }
        })
    }
    
    func doRSVP(_ event: Event, status: String) {
        let requestContent: [String: Any] = ["rsvp_status": status.lowercased()] as [String: Any]
        let res = WHAPI.sharedInstance.events.child("\(event.id)/rsvp")
        res.addObserver(self)
        res.request(.post, json: requestContent).onSuccess { response in
            if let result: Event = response.typedContent() {
                self.setEvent(result)
            }
        }
    }
    
    // MARK: Set Events
    func refreshEvents(_ items: [Event]) -> [Int] {
        var tempIds = [Int]()
        items.forEach { event in
            setEvent(event)
            let id = event.id
            tempIds.append(id)
        }
        return tempIds
    }
    
    func setEvent(_ event: Event) {
        let oldEvent = events[event.id]
        let id = event.id
        self.events[id] = event
        if let oE = oldEvent {
            if (oldEvent?.imageURL == event.imageURL && eventImages[oE] != nil) {
                eventImages[event] = eventImages.removeValue(forKey: oE)
            }
        }
        if (eventImages[event] == nil) {
            loadImage(event)
        }
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        switch (resource) {
        // Handle nearby
        case nearbyEventsResource:
            if let result: [Event] = resource.typedContent() {
                nearbyEventIds = refreshEvents(result)
            }
        case WHAPI.sharedInstance.yourEvents:
            if let result: [Event] = resource.typedContent() {
                yourEventIds = refreshEvents(result)
            }
        case WHAPI.sharedInstance.pastEvents:
            if let result: [Event] = resource.typedContent() {
                pastEventIds = refreshEvents(result)
            }
        case WHAPI.sharedInstance.upcomingEvents:
            if let result: [Event] = resource.typedContent() {
                upcomingEventIds = refreshEvents(result)
            }
        case WHAPI.sharedInstance.events:
            if let result: Event = resource.typedContent() {
                events[result.id] = result
            }
        default:
            break
        }
        
    }
}
