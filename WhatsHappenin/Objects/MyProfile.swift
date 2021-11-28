//
//  MyProfileModel.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 11/27/21.
//

import Foundation
import Siesta
import UIKit

struct MyProfile: Identifiable, Hashable, Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var username: String
    var school: School
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case school
        case email
    }
}
