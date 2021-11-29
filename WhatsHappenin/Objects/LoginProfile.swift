//
//  LoginProfile.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 11/28/21.
//

import Foundation
import Siesta
import UIKit

struct LoginProfile: Identifiable, Hashable, Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var username: String?
    var schoolId: Int?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case schoolId = "school_id"
        case email
    }
}
