//
//  MainTabbedView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/31/21.
//

import SwiftUI

struct MainTabbedView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "house")
                }
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            UserEventView(searchText: "")
                .tabItem {
                    Label("Your Events", systemImage: "calendar")
                }
            
            NearbyEventView(searchText: "")
                .tabItem {
                    Label("Nearby Events", systemImage: "list.bullet")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView()
    }
}
