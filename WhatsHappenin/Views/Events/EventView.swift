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
            Text(event.title).font(.headline)
            
            if isExpanded {
                VStack(alignment: .leading) {
                    Text(event.description)
                    Text("ADD NUM ATTENDEES")
                    //Text(event.address.description)
                }
            }
        }
    }
}
