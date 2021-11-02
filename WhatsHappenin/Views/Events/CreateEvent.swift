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
    
    @State var showAlert = false
    @State var eventName = ""
    @State var eventDesc = ""
    @State var startTime = Date()
    @State var endTime = Date()
    @State var eventType = ""
    @State var address1 = ""
    @State var address2 = ""
    @State var city = ""
    @State var state = ""
    @State var zipcode = ""
    
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
                var st = "\(startTime)"
                var et = "\(endTime)"
                
                WHAPI.sharedInstance.events.request(.post, urlEncoded:["event[title]":eventName, "event[description]":eventDesc, "event[start_date]": st, "event[end_date]": et, "event[visibility]": "school_vis", "event[address_attributes][street1]":address1,"event[address_attributes][street2]":address2, "event[address_attributes][city]":city,"event[address_attributes][state_code]":state, "event[address_attributes][country_code]":"US","event[address_attributes][postal_code]":zipcode])
                self.showAlert = true
//                cntlr.events.append(Event) This is the idea
                
                        }, label: { Text("Submit" )})
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
