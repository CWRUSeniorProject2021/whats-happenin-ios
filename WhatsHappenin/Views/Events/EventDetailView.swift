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
    
    let MAX_IMAGE_FRAME_HEIGHT: CGFloat = 500//px
    
    var body: some View {
        GeometryReader { outerGeometry in
            ZStack(alignment: .top) {
                Color.clear
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        GeometryReader { geometry in
                            Image(uiImage: getHeaderImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                                .clipped()
                                .offset(y: self.getOffsetForHeaderImage(geometry))
                        }
                        .frame(height: getScaledHeightForFrame(getHeaderImage(), geometry: outerGeometry))
                    
                        HStack(spacing: 0) {
                            Button(action: {
                                if ($event.rsvp.wrappedValue != "yes") {
                                    EventsListController.sharedInstance.doRSVP(event, status: "yes")
                                }
                            }) {
                                Text("Yes")
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background($event.rsvp.wrappedValue == "yes" ? Color("SelectedButton") : Color("UntappedButton"))
                                    .foregroundColor(Color("FontColor"))
                                    .border(width: 1, edges: [.bottom], color: .gray)
                            }
                            
                            Button(action: {
                                if ($event.rsvp.wrappedValue != "maybe") {
                                    EventsListController.sharedInstance.doRSVP(event, status: "maybe")
                                }
                            }) {
                                Text("Maybe")
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background($event.rsvp.wrappedValue == "maybe" ? Color("SelectedButton") : Color("UntappedButton"))
                                    .foregroundColor(Color("FontColor"))
                                    .border(width: 1, edges: [.bottom, .leading, .trailing], color: .gray)
                            }
                            
                            Button(action: {
                                if ($event.rsvp.wrappedValue != "no") {
                                    EventsListController.sharedInstance.doRSVP(event, status: "no")
                                }
                            }) {
                                Text("No")
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background($event.rsvp.wrappedValue == "no" ? Color("SelectedButton") : Color("UntappedButton"))
                                    .foregroundColor(Color("FontColor"))
                                    .border(width: 1, edges: [.bottom], color: .gray)
                            }
//                            Button("Yes") {
//
//                            }
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .frame(height: 50)
//                            .background(Color.green)
//
//
//
//                            Button("Maybe") {
//
//                            }
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .frame(height: 50)
//                            .background(Color.white)
//                            //.border(width: 1, edges: [.leading, .bottom, .trailing], color: Color.gray)
//                            .overlay(Divider(), alignment: .leading)
//
//                            Button("No") {
//
//                            }
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .frame(height: 50)
//                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                            .background(Color.red)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .frame(height: 50)
                        
                        VStack(alignment: .leading, spacing: 0) {
                           

                            let titleFont = Font.system(size: 30).bold()
                            Text($event.title.wrappedValue)
                                .font(titleFont)
                                .foregroundColor(Color("FontColor"))
                            
                            let descriptionFont = Font.system(size: 16)
                            Text($event.description.wrappedValue)
                                .font(descriptionFont)
                                .foregroundColor(Color("FontColor"))
                        }
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10))
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
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    private func getScaledHeightForFrame(_ image: UIImage, geometry: GeometryProxy) -> CGFloat {
        let ratio = geometry.size.width / image.size.width
        let scaledHeight = ratio * image.size.height
        let finalHeight = scaledHeight <= MAX_IMAGE_FRAME_HEIGHT ? scaledHeight : MAX_IMAGE_FRAME_HEIGHT
        return finalHeight
    }
    
    private func getHeaderImage() -> UIImage {
        if let img: UIImage = controller.eventImages[event] {
            return img
        }
        
        return UIImage(named: "SampleImage")!
    }
}



struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: Binding.constant(Event.samples()[0])).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


