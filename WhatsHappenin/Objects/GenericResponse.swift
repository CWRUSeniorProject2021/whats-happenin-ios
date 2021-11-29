//
//  GenericResponse.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/12/21.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let errors: [String: [String]]
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case errors
        case data
    }
}
