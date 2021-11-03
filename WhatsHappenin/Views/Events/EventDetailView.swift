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
    @State var event: Event
    @State private var controller: EventsListController = EventsListController.sharedInstance
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let img: UIImage = controller.eventImages[event] {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .edgesIgnoringSafeArea(.top)
                    } else {
                        Image("SampleImage")
                            .resizable()
                            .scaledToFit()
                            .edgesIgnoringSafeArea(.top)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        let titleFont = Font.system(size: 30).bold()
                        Text(event.title)
                            .font(titleFont)
                        
                        let descriptionFont = Font.system(size: 16)
                        Text(event.description)
                            .font(descriptionFont)
                    }
                    .padding(EdgeInsets(top: 5, leading: 8, bottom: 10, trailing: 10))
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



struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: Event.samples()[0]).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


