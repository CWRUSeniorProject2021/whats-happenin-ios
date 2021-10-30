//
//  EventInfoView.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 9/21/21.
//

import SwiftUI
import CoreData

struct EventInfoView : View {
    
    var body: some View {
        Form{
            Section{
            Text("Event Name:")
            Text("Event Description:")
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
                
            }
            Section{
            Text("Starts:")
            Text("Ends:")
            }
            Text("Address:")
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            Text("Phone Number:")
            Text("Email:")
        
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
            .navigationBarTitle(Text("Event Details"))
        }
    
}



struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
