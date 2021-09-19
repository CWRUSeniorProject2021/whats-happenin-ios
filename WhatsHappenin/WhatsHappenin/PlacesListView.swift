//
//  PlacesListView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 9/19/21.
//

import SwiftUI

struct PlacesListView: View {
    let places: [Place]
    @State private var selection: Set<Place> = []
    
    var body: some View {
        scrollForEach
//            list
        .navigationBarTitle(Text("Home"))
    }
    
    var list: some View {
        List(places) { place in
            PlaceView(place: place, isExpanded: self.selection.contains(place))
                .onTapGesture { self.selectDeselect(place) }
                .animation(.linear(duration: 0.3))
        }
    }
    
    var scrollForEach: some View {
        ScrollView {
            ForEach(places) { place in
                PlaceView(place: place, isExpanded: self.selection.contains(place))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect(place) }
                    .animation(.linear(duration: 0.3))
            }
        }
    }
    
    private func selectDeselect(_ place: Place) {
        if selection.contains(place) {
            selection.remove(place)
        } else {
            selection.insert(place)
        }
    }
    
}

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            content
            Divider()
        }.offset(x: 20)
    }
}

struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView(places: Place.samples())
    }
}
