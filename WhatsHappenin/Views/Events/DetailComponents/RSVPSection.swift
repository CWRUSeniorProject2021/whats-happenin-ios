//
//  RSVPSection.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/26/21.
//

import SwiftUI

struct RSVPSection: View {
    @Binding var event: Event
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                if ($event.rsvp.wrappedValue != "yes") {
                    EventsListController.sharedInstance.doRSVP(event, status: "yes")
                }
            }) {
                Text("Yes")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background($event.rsvp.wrappedValue == "yes" ? Color("SelectedButton") : Color("UntappedButton"))
                    .foregroundColor(Color("FontColor"))
                    .border(width: 1, edges: [.bottom], color: .gray)
            }
            
            Button(action: {
                if ($event.rsvp.wrappedValue != "maybe") {
                    EventsListController.sharedInstance.doRSVP(event, status: "maybe")
                }
            }) {
                Text("Maybe")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background($event.rsvp.wrappedValue == "maybe" ? Color("SelectedButton") : Color("UntappedButton"))
                    .foregroundColor(Color("FontColor"))
                    .border(width: 1, edges: [.bottom, .leading, .trailing], color: .gray)
            }
            
            Button(action: {
                if ($event.rsvp.wrappedValue != "no") {
                    EventsListController.sharedInstance.doRSVP(event, status: "no")
                }
            }) {
                Text("No")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background($event.rsvp.wrappedValue == "no" ? Color("SelectedButton") : Color("UntappedButton"))
                    .foregroundColor(Color("FontColor"))
                    .border(width: 1, edges: [.bottom], color: .gray)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .frame(height: 50)
    }
}

struct RSVPSection_Previews: PreviewProvider {
    static var previews: some View {
        RSVPSection(event: .constant(Event.samples()[0]))
    }
}
