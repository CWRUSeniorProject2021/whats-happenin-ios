//
//  NearbyEventView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI
import SwiftUIRefresh

struct NearbyEventView: View {
   
    @ObservedObject var controller = EventsListViewController.sharedInstance
    @State private var selection: Set<Event> = []
    @State private var searchText: String = ""
    @State var isRefreshing: Bool = false
    
    var body: some View {
        List($controller.nearbyEvents) { $event in
            Section(header: Text("poop")) {
            NavigationLink(destination: EventInfoView(event: event)) {
                                EventRow(event: $event)
                            }
            }
        }
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
                NavigationLink(destination: CreateEvent()) {
                    Image(systemName: "plus")
                }
              }
        }
    }
}

struct NearbyEventView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyEventView()
    }
}
