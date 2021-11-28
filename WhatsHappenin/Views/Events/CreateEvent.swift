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
    
    @Binding var event: Event?
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    @State private var eventName: String = ""
    @State private var eventDesc: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var eventType: String = ""
    @State private var address1: String = ""
    @State private var address2: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipcode: String = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: SwiftUI.Image?
    
    //things to 
    enum EventType: String, CaseIterable, Identifiable {
        case open
        case RSVP
        case restricted

        var id: String { self.rawValue }
    }
    
    init(event: Binding<Event?>){
        self._event = event
        if let e = self.event{
            self.eventName = e.title
            self.eventDesc = e.description
            self.startTime = e.startDate
            self.endTime = e.endDate
            self.address1 = e.address.street1
            self.address2 = e.address.street2 ?? ""
            self.city = e.address.city
            self.state = e.address.state.name
            self.zipcode = e.address.postalCode
            if let image = EventsListController.sharedInstance.eventImages[e]{
                self.inputImage = image
            }
            
            //initialize other shit here
        }
    }
    
    init(){
        self._event = .constant(nil)
    }
    
    
    var body: some View {
        Form {
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
            Section(header: Text("Image")) {
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    Button(action: {
                        showingImagePicker = true
                    }, label: { Text("Add an Image")})
                    .foregroundColor(.white)
                    .font(.headline)
                        
                }
            }
            
            Button(action: {
                var requestContent: [String : Any] = [
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
                
                if let img = inputImage {
                    let imageData = img.jpeg(.lowest)
                    requestContent["image"] = imageData!.base64EncodedString(options: .lineLength64Characters)
                }
                if let e = event {
                    WHAPI.sharedInstance.events.child("\(e.id)").request(.patch, json: requestContent)
                    .onSuccess { _ in
                        self.alertMessage = "Event was successfully updated"
                        self.showAlert = true
                    }
                    .onFailure { _ in
                        self.alertMessage = "There was an error in updating event"
                        self.showAlert = true
                    }

                }else{
                    WHAPI.sharedInstance.events.request(.post, json: requestContent)
                        .onSuccess { _ in
                            self.alertMessage = "Event was successfully created"
                            self.showAlert = true
                        }
                        .onFailure { _ in
                            self.alertMessage = "There was an error creating the event"
                            self.showAlert = true
                        }
                }
                
            }, label: {
                if let e = event{
                    Text("Save")
                } else {
                    Text("Submit")
                }
            })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text($alertMessage.wrappedValue),
                        dismissButton: .default(Text("Close"))
                    )
                }
        }
        .navigationTitle("Create Event")
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}



struct CreateEvent_Previews: PreviewProvider {
    static var previews: some View {
        CreateEvent().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
