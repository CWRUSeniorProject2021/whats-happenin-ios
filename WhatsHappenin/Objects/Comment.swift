//
//  Comment.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation

struct Comment: Hashable, Codable {
    var id: Int
    var text: String
    var parentId: Int?
//    var commenterName: String
//    var commenterId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case text = "comment"
        case parentId = "parent_id"
//        case commenterName = "commenter_name"
//        case commenterId = "commenter_id"
    }
}
