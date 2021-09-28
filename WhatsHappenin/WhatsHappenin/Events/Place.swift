//
//  Place.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 9/19/21.
//

import Foundation
struct Place: Identifiable, Hashable {
    let id: Int
    let eventName: String
    let eventDesc: String
    let numAttendees: String
    let address: String
   
    
    static func samples() -> [Place] { (0..<50).map(Place.fixture) }
    
    private static func fixture(_ id: Int) -> Place {
        Place(
            id: id,
            eventName: "Event Name #\(id)",
            eventDesc: "Desc of event here: ",
            numAttendees: "Number of Attendees #\(id)",
            address: "Address of event here: "
        )
    }
}
