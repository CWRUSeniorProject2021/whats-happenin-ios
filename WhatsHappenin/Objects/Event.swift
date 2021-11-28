//
//  Event.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 9/19/21.
//

import Foundation
import Siesta
import UIKit

struct Event: Identifiable, Hashable, Codable, Imageable {

    var id: Int
    var title: String
    var description: String
    var attendeeLimit: Int
    var address: Address
    var startDate: Date
    var endDate: Date
    var rsvp: String
    var isOwnEvent: Bool
    var comments: [Comment]
    
    var imageURL: String? {
        didSet {
            print("SET VARIABLE")
        }
    }
    var imageResource: Resource?
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case attendeeLimit = "attendee_limit"
        case address
        case startDate = "start_date"
        case endDate = "end_date"
        case isOwnEvent = "is_own_event"
        case comments
        case imageURL = "image_url"
        case rsvp = "rsvp_status"
    }
   
//    mutating func loadImage() {
//        if let url: String = imageURL {
//            self.imageResource = WHAPI.sharedInstance.resource(absoluteURL: url)
//            if let resource: Resource = self.imageResource {
//                resource.load()
//                    .onSuccess { response in
//                        print(response)
//                        print("image loaded")
//                        DispatchQueue.main.async {
//                            if let img: UIImage = response.typedContent() {
//                                self.image = img
//                            }
//                        }
//                    }
//                    .onFailure { response in
//                        print("image failed")
//                    }
//            }
//        }
//    }
    
    static func samples() -> [Event] { (0..<50).map(Event.fixture) }

    private static func fixture(_ id: Int) -> Event {
        Event(
            id: id,
            title: "Event Title #\(id)",
            description: "Desc of event here: ",
            attendeeLimit: 100,
            address: Address(street1: "1750 Ansel Rd", city: "Cleveland", postalCode: "44106", state: StateAddress(name: "Ohio", code: "OH"), country: Country(name: "United States", code: "US"), coordinates: CoordinatePair(latitude: 41.50412, longitude: -81.60944)),
            startDate: Date(),
            endDate: Date().addingTimeInterval(TimeInterval(3600)),
            rsvp: "maybe",
            isOwnEvent: true,
            comments: [
                Comment(id: 0, text: "I am parent 1", parentId: nil, createdAt: Date().addingTimeInterval(-100000)),
                Comment(id: 1, text: "I am child 1 with asmfjsdkjdfhsj lots and lots and lots of long text blah blah blah \n\n\nblah blah blah", parentId: 0, createdAt: Date().addingTimeInterval(-5000)),
                Comment(id: 2, text: "I am parent 2", parentId: nil, createdAt: Date().addingTimeInterval(-3550)),
                Comment(id: 3, text: "I am parent 3", parentId: nil, createdAt: Date().addingTimeInterval(-3100)),
                Comment(id: 4, text: "I am child 2 with short text", parentId: 3, createdAt: Date().addingTimeInterval(-3000)),
                Comment(id: 5, text: "I am parent 4", parentId: nil, createdAt: Date().addingTimeInterval(-10)),
                
            ]
        )
    }
    
}

struct EventList: Codable {
    let events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case events
    }
}

struct SingleEvent: Codable {
    let event: Event
    
    enum CodingKeys: String, CodingKey {
        case event
    }
}
