//
//  createEvent.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 9/21/21.
//
import SwiftUI
import CoreData
import Siesta

struct CreateEvent : View {
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    @State var eventName: String = ""
    @State var eventDesc: String = ""
    @State var startTime: Date = Date()
    @State var endTime: Date = Date()
    @State var eventType: String = ""
    @State var address1: String = ""
    @State var address2: String = ""
    @State var city: String = ""
    @State var state: String = ""
    @State var zipcode: String = ""
    
    //things to 
    enum EventType: String, CaseIterable, Identifiable {
            case open
            case RSVP
            case restricted

            var id: String { self.rawValue }
        }
    
    
    var body: some View {
        Form{
            Section(header: Text("Event Information")){
                TextField("Event Name", text: $eventName)
                TextField("Event Description", text: $eventDesc)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                            .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
                DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                    
                DatePicker("End Time", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
                
                Picker("EventType", selection: $eventType) {
                                        ForEach(EventType.allCases) { eventType in
                                            Text(eventType.rawValue.capitalized).tag(eventType)
                                        }
                            }.pickerStyle(SegmentedPickerStyle())
                
                
                
            }
            Section(header: Text("Event Location")){
                TextField("Address Line 1", text: $address1)
                TextField("Address Line 2", text: $address2)
                TextField("City", text: $city)
                TextField("State", text: $state)
                TextField("Zipcode", text: $zipcode)
            }
            Button(action: {
                let requestContent: [String : Any] = [
                    "title": eventName,
                    "description": eventDesc,
                    "start_date": "\(startTime)",
                    "end_date": "\(endTime)",
                    "visibility": "school_vis",
                    "address_attributes": [
                        "street1": address1,
                        "street2": address2,
                        "city": city,
                        "state_code": state,
                        "country_code": "US",
                        "postal_code": zipcode
                    ]
                ] as [String : Any]
                
                WHAPI.sharedInstance.events.request(.post, json: requestContent)
                    .onSuccess { _ in
                        self.alertMessage = "Event was successfully created"
                        self.showAlert = true
                    }
                    .onFailure { _ in
                        self.alertMessage = "There was an error creating the event"
                        self.showAlert = true
                    }
                
            }, label: { Text("Submit")})
                .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Event Successfully Created"),
                            dismissButton: .default(Text("Close"))
                        )
                    }
            }
            .navigationBarTitle(Text("Create Event"))
        }
    
}



struct CreateEvent_Previews: PreviewProvider {
    static var previews: some View {
        CreateEvent().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
