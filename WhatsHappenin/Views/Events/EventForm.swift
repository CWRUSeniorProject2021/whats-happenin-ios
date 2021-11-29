//
//  EventForm.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 9/21/21.
//
import SwiftUI
import CoreData
import Siesta

struct EventForm : View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let event: Event?
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    @State var alertBody: String = ""
    @State private var eventName: String
    @State private var eventDesc: String
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var eventType: String
    @State private var address1: String
    @State private var address2: String
    @State private var city: String
    @State private var state: String
    @State private var zipcode: String
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: SwiftUI.Image?
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case title
        case description
        case street1
        case street2
        case city
        case postalCode
    }
    
    let stateList: [String] = ["AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MP", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UM", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
    
    //things to 
    enum EventType: String, CaseIterable, Identifiable {
        case open
        case RSVP
        case restricted

        var id: String { self.rawValue }
    }

    
    init(for event: Event?) {
        self.event = event
        
        self._eventName = State(initialValue: event?.title ?? "")
        self._eventDesc = State(initialValue: event?.description ?? "")
        self._startTime = State(initialValue: event?.startDate ?? Date())
        self._endTime = State(initialValue: event?.endDate ?? Date().addingTimeInterval(3600))
        self._eventType = State(initialValue: "restricted")
        self._address1 = State(initialValue: event?.address.street1 ?? "")
        self._address2 = State(initialValue: event?.address.street2 ?? "")
        self._city = State(initialValue: event?.address.city ?? "")
        self._state = State(initialValue: event?.address.state.code ?? "")
        self._zipcode = State(initialValue: event?.address.postalCode ?? "")
    }
    
    init() {
        self.init(for: nil)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Event Information")){
                TextField("Event Name", text: $eventName)
                    .focused($focusedField, equals: .title)
                TextField("Event Description", text: $eventDesc)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                            .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
                            .focused($focusedField, equals: .description)
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
                    .focused($focusedField, equals: .street1)
                TextField("Address Line 2", text: $address2)
                    .focused($focusedField, equals: .street1)
                TextField("City", text: $city)
                    .focused($focusedField, equals: .city)
                Picker("State", selection: $state) {
                    ForEach(stateList, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Zipcode", text: $zipcode)
                    .focused($focusedField, equals: .postalCode)
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
                    .foregroundColor(Color("FontColor"))
                    //.font(.headline)
                        
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
                    requestContent["image_64"] = imageData!.base64EncodedString(options: .lineLength64Characters)
                }
                if let e = event {
                    WHAPI.sharedInstance.events.child("\(e.id)").request(.patch, json: requestContent)
                    .onSuccess { _ in
                        EventsListController.sharedInstance.reloadEvent(e.id)
                        self.alertMessage = "Event was successfully updated"
                        self.showAlert = true
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .onFailure { error in
                        self.alertMessage = "There was an error in updating event"
                        let val : GenericResponse<Empty>? = WHAPI.sharedInstance.parseErrors(error)

                        var err: String = ""
                        for (a , b ) in val?.errors ?? [:] {
                            var temp = a.replacingOccurrences(of: "address.", with: "")
                            temp = temp.replacingOccurrences(of: "_", with: " ")
                                for c in b {
                                    err = err + "\n" + temp + " " + c
                                }
                        }
                        alertBody = err
                        self.showAlert = true
                    }

                }else{
                    WHAPI.sharedInstance.events.request(.post, json: requestContent)
                        .onSuccess { _ in
                            self.alertMessage = "Event was successfully created"
                            self.showAlert = true
                            EventsListController.sharedInstance.loadYourEvents()
                            EventsListController.sharedInstance.loadNearbyEvents()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        .onFailure { error in
                            self.alertMessage = "There was an error creating the event"
                            let val : GenericResponse<Empty>? = WHAPI.sharedInstance.parseErrors(error)

                            var err: String = ""
                            for (a , b ) in val?.errors ?? [:] {
                                var temp = a.replacingOccurrences(of: "address.", with: "")
                                temp = temp.replacingOccurrences(of: "_", with: " ")
                                    for c in b {
                                        err = err + "\n" + temp + " " + c
                                    }
                            }
                            alertBody = err
                            self.showAlert = true
                        }
                }
                
            }, label: {
                
                if (event != nil) {
                    Text("Save")
                } else {
                    Text("Submit")
                }
            })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text($alertMessage.wrappedValue),
                        message: Text($alertBody.wrappedValue),
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
        EventForm(for: Event.samples()[0]).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
