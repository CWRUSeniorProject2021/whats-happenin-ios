//
//  NearbyEventView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI
import SwiftUIRefresh

struct NearbyEventView: View {
    @StateObject var controller = EventsListController.sharedInstance
    @State private var searchText = ""
    @State var isRefreshing: Bool = false
    
//    var filteredEvents: Binding<[Event]> {
//        if searchText.isEmpty {
//            return $controller.nearbyEvents
//        } else {
//            return $controller.nearbyEvents.filter {
//                $0.title.localizedCaseInsensitiveContains(searchText.localizedLowercase)
//            }
//        }
//    }
    
    var body: some View {
        NavigationView{
//            SearchBar(text1: $searchText)
            List($controller.nearbyEvents) { $event in
                EventRow(event: $event, controller: controller)
            }
            .searchable(text: $controller.searchTerm)
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
                    NavigationLink(destination: CreateEvent()) {
                        Image(systemName: "plus")
                    }
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
