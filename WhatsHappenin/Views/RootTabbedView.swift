//
//  RootTabbedView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/31/21.
//

import SwiftUI

struct RootTabbedView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        TabView {
            NavigationView {
                FeedView()
            }
            .tabItem {
                Label("Feed", systemImage: "house")
            }
            
            NavigationView {
                MapView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            
            NavigationView {
                UserEventView(searchText: "")
            }
            .tabItem {
                Label("Your Events", systemImage: "calendar")
            }
            
            NavigationView {
                NearbyEventView()
                    .navigationTitle("Nearby Events")
            }
            .tabItem {
                Label("Nearby Events", systemImage: "list.bullet")
            }
            
            NavigationView {
                ProfileView(isLoggedIn: $isLoggedIn)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabbedView(isLoggedIn: .constant(false))
    }
}