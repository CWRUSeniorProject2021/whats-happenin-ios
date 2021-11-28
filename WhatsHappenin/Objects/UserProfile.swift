//
//  UserProfile.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/28/21.
//

import Foundation
import UIKit

struct UserProfile: Identifiable, Hashable, Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var username: String
    var school: School
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case school
    }
}
