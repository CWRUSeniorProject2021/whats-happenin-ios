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
    @State var searchText: String
    @State var isRefreshing: Bool = false
    
    var body: some View {
        VStack {
            SearchBar(text1: $searchText)

            //Filter no longer works but list opens :)
            List {
                ForEach(controller.events.indices, id: \.self) { index in
                    NavigationLink(controller.events[index].title, destination: EventInfoView())
                }
            }
            .pullToRefresh(isShowing: $isRefreshing) {
                controller.reloadNearbyEvents()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.isRefreshing = false
                                }
            }
            .onChange(of: self.isRefreshing) { value in
            }
        }
        .navigationTitle("Nearby Events")
        .navigationBarTitleDisplayMode(.inline)
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
        NearbyEventView(searchText: "")
    }
}
