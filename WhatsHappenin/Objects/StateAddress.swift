//
//  StateAddress.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation

struct StateAddress: Hashable, Codable {
    var name: String
    var code: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
    }
}
