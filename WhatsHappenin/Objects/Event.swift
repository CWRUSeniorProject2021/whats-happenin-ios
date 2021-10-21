//
//  Event.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 9/19/21.
//

import Foundation
import Siesta

struct Event: Identifiable, Hashable, Codable {
    var id: Int
    var title: String
    var description: String
    var attendeeLimit: Int
    var address: Address
    var startDate: String
    var endDate: String
    var comments: [Comment]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case attendeeLimit = "attendee_limit"
        case address
        case startDate = "start_date"
        case endDate = "end_date"
        case comments
    }
   
    
    static func samples() -> [Event] { (0..<50).map(Event.fixture) }

    private static func fixture(_ id: Int) -> Event {
        Event(
            id: id,
            title: "Event Title #\(id)",
            description: "Desc of event here: ",
            attendeeLimit: 100,
            address: Address(street1: "1750 Ansel Rd", city: "Cleveland", postalCode: "44106", state: StateAddress(name: "Ohio", code: "OH"), country: Country(name: "United States", code: "US")),
            startDate: "sd",//Date(),
            endDate: "ed"//Date().addingTimeInterval(TimeInterval(3600))
        )
    }
    
//    static func eventsFromResource(_ resource: Resource) -> [Event] {
//        let decoder = JSONDecoder()
//        let json = resource.jsonDict
//        let errors = json["errors"]
//        let data = json["data"]
//        let eventArray = json["events"]
//        try decoder.decode([String: String].self, from: eventArray)
//
//        return []
//    }
}

struct EventList: Codable {
    let events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case events
    }
}
