//
//  EventDetailView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/3/21.
//

import SwiftUI
import CoreData
import MapKit

struct EventDetailView : View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var event: Event
    @State private var controller: EventsListController = EventsListController.sharedInstance
    @State private var rsvpStatus: RSVPStatus = RSVPStatus.no
    
    @GestureState private var dragOffset = CGSize.zero

    
    var body: some View {
        GeometryReader { outerGeometry in
            ZStack(alignment: .top) {
                Color.clear
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        DetailImageWithTitle(event: $event, outerGeometry: .constant(outerGeometry))
                    
                        RSVPSection(event: $event)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Image(systemName: "clock")
                                    .font(Font.system(size: 30))
                                    .foregroundColor(Color("IconColor"))
                                
                                let startDate = $event.startDate.wrappedValue
                                let endDate = $event.endDate.wrappedValue
                                
                                Text(dateDiff(startDate, to: endDate))
                                    .foregroundColor(Color("FontColor"))
                            }
                            .padding()
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "map")
                                    .font(Font.system(size: 30))
                                    .foregroundColor(Color("IconColor"))
                                
                                let a = $event.address.wrappedValue
                                Text(a.stringRepr)
                                    .foregroundColor(Color("FontColor"))
                            }
                            .padding()
                            
                            if let coords = event.address.coordinates {
                                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(
                                                latitude: coords.latitude,
                                                longitude: coords.longitude),
                                            latitudinalMeters: 300,
                                            longitudinalMeters: 300
                                        )),
                                        annotationItems: [IdentifiablePlace(id: event.id, coords: coords)]) { place in
                                        MapMarker(coordinate: place.location,
                                                  tint: Color.red)
                                        
                                    }
                                    .scaledToFill()
                                    .allowsHitTesting(false)
                            }

                            Divider()
                            
                            HStack {
                                Image(systemName: "text.bubble")
                                    .font(Font.system(size: 30))
                                    .foregroundColor(Color("IconColor"))
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Description")
                                        .font(Font.system(size: 16))
                                        .foregroundColor(Color("FontColor"))
                                    
                                    let descriptionFont = Font.system(size: 16)
                                    Text($event.description.wrappedValue)
                                        .font(descriptionFont)
                                        .foregroundColor(Color("FontColor"))
                                }
                            }
                            .padding()

                            Divider()
                            
                            CommentsSectionView(event: $event)
                                .padding()
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
        }
        // Add in a hacky gesture recognizer to go back to prev view
        //https://stackoverflow.com/questions/58234142/how-to-give-back-swipe-gesture-in-swiftui-the-same-behaviour-as-in-uikit-intera
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
             if(value.startLocation.x < 50 && value.translation.width > 100) {
                 self.presentationMode.wrappedValue.dismiss()
             }
        }))
    }
    
    private func dateDiff(_ from: Date, to: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        let diff = Calendar.current.dateComponents([.day], from: from, to: to)
        let longFormat = "EEEE, MMM d, yyy hh:mm a"
        let timeOnly = "hh:mm a"

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


