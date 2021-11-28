//
//  RootTabbedView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/31/21.
//

import SwiftUI

struct RootTabbedView: View {
    @Binding var isLoggedIn: Bool
    
    init(isLoggedIn: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
        let tabBarAppearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView {
//            NavigationView {
//                FeedView()
//                    .navigationTitle("Feed")
//            }
//            .tabItem {
//                Label("Feed", systemImage: "house")
//            }
            
            NavigationView {
                MapView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            
            NavigationView {
                UserEventView()
                    .navigationBarTitle("", displayMode: .inline)
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
