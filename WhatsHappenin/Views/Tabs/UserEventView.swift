//
//  UserEventView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI
import SwiftUIRefresh

struct UserEventView: View {
    
    @ObservedObject var controller = EventsListViewController.sharedInstance
    @State var searchText: String
    
    @State var isRefreshing: Bool = false
    var body: some View {
        VStack {
            SearchBar(text1: $searchText)
            List(controller.nearbyEvents) { event in
                NavigationLink(event.title, destination: EventInfoView())}
            .pullToRefresh(isShowing: $isRefreshing) {
                controller.reloadNearbyEvents()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isRefreshing = false
                }
            }
            .onChange(of: self.isRefreshing) { value in
            }
        }
        .navigationTitle("Your Events")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserEventView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventView(searchText: "")
    }
}