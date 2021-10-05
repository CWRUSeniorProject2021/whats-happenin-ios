//
//  Event.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 9/19/21.
//

import Foundation
struct Event: Identifiable, Hashable {
    let id: Int
    let eventName: String
    let eventDesc: String
    let numAttendees: String
    let address: String
   
    
    static func samples() -> [Event] { (0..<50).map(Event.fixture) }
    
    private static func fixture(_ id: Int) -> Event {
        Event(
            id: id,
            eventName: "Event Name #\(id)",
            eventDesc: "Desc of event here: ",
            numAttendees: "Number of Attendees #\(id)",
            address: "Address of event here: "
        )
    }
}
