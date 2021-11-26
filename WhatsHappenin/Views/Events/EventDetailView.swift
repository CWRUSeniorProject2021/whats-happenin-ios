//
//  EventDetailView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/3/21.
//

import SwiftUI
import CoreData

struct EventDetailView : View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var event: Event
    @State private var controller: EventsListController = EventsListController.sharedInstance
    @State private var rsvpStatus: RSVPStatus = RSVPStatus.no
        
    var body: some View {
        GeometryReader { outerGeometry in
            ZStack(alignment: .top) {
                Color.clear
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        DetailImageWithTitle(event: $event, outerGeometry: .constant(outerGeometry))
                    
                        RSVPSection(event: $event)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            let startDate = $event.startDate.wrappedValue
                            let endDate = $event.endDate.wrappedValue
                            
                            Text(dateDiff(startDate, to: endDate))
                                .foregroundColor(Color("FontColor"))
                                .padding()
                            
                            Divider()
                            
                            Text("LOCATION INFO")
                                .foregroundColor(Color("FontColor"))
                                .padding()
                            
                            Divider()
                            
                            let descriptionFont = Font.system(size: 16)
                            Text($event.description.wrappedValue)
                                .font(descriptionFont)
                                .foregroundColor(Color("FontColor"))
                                .padding()
                            Divider()
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    let backIconFont = Font.system(size: 30)
                    Image(systemName: "chevron.backward.circle.fill")
                        .font(backIconFont)
                        .padding()
                    //.foregroundColor(Color("IconColor"))
                    Spacer()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
            //        Form{
            //            Section{
            //                Text("Event Name: \(event.title)")
            //                Text("Event Description: \(event.description)")
            //                .lineLimit(4)
            //                .multilineTextAlignment(.leading)
            //                .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
            //            }
            //
            //            Section{
            //                Text("Starts: \(event.startDate)")
            //                Text("Ends: \(event.endDate)")
            //                //Text("Starts: \(dateFormatter.string(from: event.startDate))")
            //                //Text("Ends: \(dateFormatter.string(from: event.endDate))")
            //            }
            //
            //            Text("Address: \(event.address.stringRepr)")
            //                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            //
            //            Section{
            //            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            //                Text("RSVP")
            //            })
            //
            //            }
            //
            //            Section{
            //                Text("Comments:")
            //                    .lineLimit(4)
            //                    .multilineTextAlignment(.leading)
            //                    .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
            //
            //                Text("Type Your Comment Here")
            //
            //                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            //                    Text("Add Comment")
            //                })
            //            }
            //            }
            //            .navigationTitle("Event Details")
            //        }
        }
    }
    
    private func dateDiff(_ from: Date, to: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        let diff = Calendar.current.dateComponents([.day], from: from, to: to)
        let longFormat = "EEEE, MMM d, yyy HH:mm a"
        let timeOnly = "HH:mm a"

        dateFormatter.dateFormat = longFormat
        if (diff.day == 0) {
            let sD = dateFormatter.string(from: from)
            dateFormatter.dateFormat = timeOnly
            let eD = dateFormatter.string(from: to)
            return "\(sD) - \(eD)"
        } else {
            let sD = dateFormatter.string(from: from)
            let eD = dateFormatter.string(from: to)
            return "\(sD) - \(eD)"
        }
    }
}



struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: Binding.constant(Event.samples()[0])).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


