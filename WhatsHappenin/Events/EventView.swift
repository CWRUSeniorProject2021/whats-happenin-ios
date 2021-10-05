//
//  EventView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 9/19/21.
//

import Foundation
import SwiftUI

struct EventView: View {
    let event: Event
    let isExpanded: Bool
    
    var body: some View {
        HStack {
            content
            Spacer()
        }
        .contentShape(Rectangle())
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            Text(event.eventName).font(.headline)
            
            if isExpanded {
                VStack(alignment: .leading) {
                    Text(event.eventDesc)
                    Text(event.numAttendees)
                    Text(event.address)
                }
            }
        }
    }
}
