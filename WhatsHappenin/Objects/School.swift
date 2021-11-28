//
//  School.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 11/28/21.
//

import Foundation
import Siesta
import UIKit

struct School: Identifiable, Hashable, Codable{
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

