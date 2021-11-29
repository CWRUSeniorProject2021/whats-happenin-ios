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
    @GestureState private var dragOffset = CGSize.zero
    @Binding var event: Event
    @State private var controller: EventsListController = EventsListController.sharedInstance
    @State private var rsvpStatus: RSVPStatus = RSVPStatus.no
    
    @ObservedObject var newCommentData: NewCommentData = NewCommentData()
    @State private var isPostingComment: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
            case commentField
        }
    
    var body: some View {
        GeometryReader { outerGeometry in
            ZStack(alignment: .top) {
                Color.clear
                ScrollView(showsIndicators: false) {
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
                            
                            CommentsSectionView(event: $event, newCommentData: newCommentData)
                                .padding()
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .onTapGesture {
                    focusedField = nil
                    newCommentData.isCommenting = false
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            let backIconFont = Font.system(size: 30)
                            Image(systemName: "chevron.backward.circle.fill")
                                .font(backIconFont)
                                .foregroundColor(Color.blue)
                            //.foregroundColor(Color("IconColor"))
                        }
                        
                        Spacer()
                        
                        if (event.isOwnEvent) {
                            NavigationLink(destination: EventForm(for: self.event)) {
                                let dropdownFont = Font.system(size: 30)
                                Image(systemName: "pencil.circle.fill")
                                    .font(dropdownFont)
                                    .foregroundColor(Color.blue)
                            }
                        }
                        
                        Menu {
                            Button(action: {
                                EventsListController.sharedInstance.reloadEvent(event)
                            }) {
                                Text("Refresh")
                            }
                            if(event.isOwnEvent){
                            Button(role: .destructive, action: {
                                // DO DELETE CONFIRMATIION HERE
                                showDeleteAlert = true
                            }) {
                                Label("Delete Event", systemImage: "")
                            }
                    
                            }
                        } label : {
                            let dropdownFont = Font.system(size: 30)
                            Image(systemName: "ellipsis.circle.fill")
                                .font(dropdownFont)
                                .foregroundColor(Color.blue)
                        }
                        
                    }
                    .padding(.top, 55)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                    
                    if (newCommentData.isCommenting) {
                        ZStack() {
                            HStack(spacing: 0) {
                                TextField($newCommentData.placeholder.wrappedValue ?? "Add a comment...",
                                          text: $newCommentData.text)
                                    .focused($focusedField, equals: .commentField)
                                    .padding(.leading, 15)
                                    .padding(.trailing, 5)
                                
                                Spacer()
                                
                                Button(action: {
                                    if (newCommentData.text != "") {
                                        self.isPostingComment = true
                                        let requestData: [String: Any] = [
                                            "text": newCommentData.text,
                                            "parent_id": newCommentData.parentId ?? ""
                                        ] as [String: Any]
                                        WHAPI.sharedInstance.events.child("\(event.id)").child("comments").request(.post, json: requestData)
                                            .onSuccess { response in
                                                self.isPostingComment = false
                                                self.newCommentData.isCommenting = false
                                                self.focusedField = .none
                                                EventsListController.sharedInstance.reloadEvent(event)
                                            }
                                            .onFailure { error in
                                                self.isPostingComment = false
                                                // HANDLE FAILURE HERE
                                            }
                                    }
                                }) {
                                    let submitButtonFont = Font.system(size:16)
                                    Text("Post")
                                        .font(submitButtonFont)
                                }
                                .padding(.trailing, 20)
                                .padding(.vertical, 10)
                                .disabled(self.isPostingComment)
                                                        
                            }
                            .background(Color("TextInput"))
                            .cornerRadius(20)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                        }
                        .onAppear {
                            self.focusedField = .commentField
                        }
                        .frame(width: outerGeometry.size.width, height: 65)
                        .background(Color("ListRowColor")
                                        .shadow(color: Color("LightFontColor"), radius: 6, x: 0, y: 0)
                                        .mask(Rectangle()
                                                .padding(.top, -20)
                                                .edgesIgnoringSafeArea(.all)))
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Caution"),
                    message: Text("Are you sure you want to delete event?"),
                    primaryButton: .default(Text("Yes")){
                        print("deleting")
                        WHAPI.sharedInstance.events.child("\(event.id)").request(.delete)
                            .onSuccess{ _ in
                            print("great success")
                            }
                            .onFailure{ _ in
                            print("grape")
                            }
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .destructive(Text("Cancel"))
                )
            }
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


