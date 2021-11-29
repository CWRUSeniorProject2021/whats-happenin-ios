//
//  NearbyEventView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI
import SwiftUIRefresh

struct NearbyEventView: View {
   
    @ObservedObject var controller = EventsListController.sharedInstance
    @State private var searchText: String = ""
    @State var isRefreshing: Bool = false
    
    var body: some View {
        //if ($controller.nearbyEvents.wrappedValue.count > 0) {
            List($controller.nearbyEvents) { $event in
                EventRow(event: $event, controller: controller)
            }
            .padding(EdgeInsets(top: 44, leading: 0, bottom: 24, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .listStyle(PlainListStyle())
            .pullToRefresh(isShowing: $isRefreshing) {
                controller.loadNearbyEvents()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.isRefreshing = false
                                }
            }
            .onChange(of: self.isRefreshing) { value in
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EventForm()) {
                        Image(systemName: "plus")
                    }
                  }
            }
//        } else {
//            List(0..<1) { r in
//                Text("No Events to Display!")
//            }
//            .padding(EdgeInsets(top: 44, leading: 0, bottom: 24, trailing: 0))
//            .edgesIgnoringSafeArea(.all)
//            .listStyle(PlainListStyle())
//            .pullToRefresh(isShowing: $isRefreshing) {
//                controller.loadNearbyEvents()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                    self.isRefreshing = false
//                                }
//            }
//            .onChange(of: self.isRefreshing) { value in
//            }
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: EventForm()) {
//                        Image(systemName: "plus")
//                    }
//                  }
//            }
//        }
    }
}

struct NearbyEventView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyEventView()
    }
}
