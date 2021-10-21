//
//  PlaceView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 9/19/21.
//

import Foundation
import SwiftUI

struct PlaceView: View {
    let place: Place
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
            Text(place.eventName).font(.headline)
            
            if isExpanded {
                VStack(alignment: .leading) {
                    Text(place.eventDesc)
                    Text(place.numAttendees)
                    Text(place.address)
                }
            }
        }
    }
}
