//
//  GenericResponse.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/12/21.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
