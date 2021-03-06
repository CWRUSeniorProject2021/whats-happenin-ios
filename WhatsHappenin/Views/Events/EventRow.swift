//
//  EventRow.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/2/21.
//

import SwiftUI

struct EventRow: View {
    @Binding var event: Event
    @ObservedObject var controller: EventsListController
    
    var body: some View {
        ZStack {
            Color("ListRowColor")
            NavigationLink(destination: EventDetailView(event: $event)) { EmptyView() }
            .buttonStyle(PlainButtonStyle())
            .opacity(0.0)
            VStack {
//                if let url: String = event.imageURL {
//                    AsyncImage(url: URL(string: url)) { image in
//                        image
//                            .resizable()
//                            .scaledToFit()
//                    } placeholder: {
//                        ProgressView()
//                    }
//                } else {
//                    Image("SampleImage")
//                        .resizable()
//                        .scaledToFit()
//                }
               if let img: UIImage = controller.eventImages[event] {
                   Image(uiImage: img)
                       .resizable()
                       .scaledToFit()
               } else {
                   Image("SampleImage")
                       .resizable()
                       .scaledToFit()
               }
                
                VStack {
                    Text(event.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("FontColor"))
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(event.description)
                        .font(.body)
                        .foregroundColor(Color("FontColor"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 2)
        .listRowSeparator(.hidden)
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(event: .constant(Event.samples()[0]), controller: EventsListController.sharedInstance)
    }
}
