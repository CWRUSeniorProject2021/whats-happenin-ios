//
//  createEvent.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 9/21/21.
//
import SwiftUI
import CoreData

struct CreateEvent : View {
    
    @State var showAlert = false
    @State var eventName = ""
    @State var eventDesc = ""
    @State var startTime = Date()
    @State var endTime = Date()
    @State var eventType = ""
    
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
            Button(action: {
                            self.showAlert = true
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
