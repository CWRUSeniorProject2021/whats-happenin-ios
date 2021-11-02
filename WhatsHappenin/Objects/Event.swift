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
    var startDate: Date
    var endDate: Date
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
            startDate: Date(),
            endDate: Date().addingTimeInterval(TimeInterval(3600))
        )
    }
}

struct EventList: Codable {
    let events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case events
    }
}
