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
        //SearchBar(text1: $searchText)
        //    .padding(.top, -30)
        List {
            ForEach(controller.nearbyEvents.indices, id: \.self) { index in
                NavigationLink(destination: EventInfoView()) {
                    EventRow(event: $controller.nearbyEvents[index])
                }
            }
        }
        //.searchable(text: $searchText) IOS 15 only
        .pullToRefresh(isShowing: $isRefreshing) {
            controller.reloadNearbyEvents()
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
