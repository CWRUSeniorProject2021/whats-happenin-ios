//
//  RSVPStatus.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/19/21.
//

import Foundation

enum RSVPStatus: String, CaseIterable, Identifiable {
    case yes
    case maybe
    case no
    
    var id: String { self.rawValue }
}
