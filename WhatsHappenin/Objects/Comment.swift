//
//  Comment.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation

struct Comment: Hashable, Codable, Identifiable {
    var id: Int
    var text: String
    var parentId: Int?
    var createdAt: Date
    var commenterName: String = "ctingle"
    var commenterId: Int = 1
    
    enum CodingKeys: String, CodingKey {
        case id
        case text = "text"
        case parentId = "parent_id"
        case createdAt = "created_at"
        case commenterName = "commenter_name"
        case commenterId = "commenter_id"
    }
}
