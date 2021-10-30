//
//  Buttons.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI

struct Buttons: View {
    var body: some View {
        HStack {
            FeedViewButton()
            Spacer()
            MapViewButton()
            Spacer()
            UserEventsButton()
            Spacer()
            NearbyEventButton()
            Spacer()
            ProfileViewButton()
        }.padding(.horizontal)
        
}
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Buttons()
    }
}

struct FeedViewButton: View {
    var body: some View {
        NavigationLink(destination: FeedView()) {
            Image(systemName: "house")
                .font(.system(
                        size: 25,
                        weight: .regular,
                        design: .default))
                .foregroundColor(.black)
    }
}
}
struct MapViewButton: View {
    var body: some View {
        NavigationLink(destination: MapView()) {
            Image(systemName: "map")
                .font(.system(
                        size: 25,
                        weight: .regular,
                        design: .default))
                .foregroundColor(.black)
    }
    }
}
struct UserEventsButton: View {
    var body: some View {
        NavigationLink(destination: UserEventView(searchText: "")) {
            Image(systemName: "calendar")
                .font(.system(
                        size: 25,
                        weight: .regular,
                        design: .default))
                .foregroundColor(.black)
    }
    }
}
struct NearbyEventButton: View {
    var body: some View {
        NavigationLink(destination: NearbyEventView(searchText: "")) {
            Image(systemName: "list.bullet")
                .font(.system(
                        size: 25,
                        weight: .regular,
                        design: .default))
                .foregroundColor(.black)
    }
    }
}
struct ProfileViewButton: View {
    var body: some View {
        NavigationLink(destination: ProfileView()) {
            Image(systemName: "person")
                .font(.system(
                        size: 25,
                        weight: .regular,
                        design: .default))
                .foregroundColor(.black)
    }
    }
}
