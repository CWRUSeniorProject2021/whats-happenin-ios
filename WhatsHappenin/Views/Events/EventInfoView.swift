//
//  EventInfoView.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 9/21/21.
//

import SwiftUI
import CoreData


struct EventInfoView : View {
    @State var event: Event
    
    var body: some View {
        Form{
            Section{
                Text("Event Name: \(event.title)")
                Text("Event Description: \(event.description)")
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
            }
            
            Section{
                Text("Starts: \(event.startDate)")
                Text("Ends: \(event.endDate)")
                //Text("Starts: \(dateFormatter.string(from: event.startDate))")
                //Text("Ends: \(dateFormatter.string(from: event.endDate))")
            }
            
            Text("Address:")
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)

            Section{
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("RSVP")
            })
                
            }
            
            Section{
                Text("Comments:")
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
                
                Text("Type Your Comment Here")
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Add Comment")
                })
            }
            }
            .navigationTitle("Event Details")
        }
    
}



//struct EventInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventInfoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
