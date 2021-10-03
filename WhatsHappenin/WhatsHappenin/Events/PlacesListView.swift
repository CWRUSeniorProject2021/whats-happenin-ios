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
    @State var selectedIndex = 0
    let icons = [
        "house",
        "map",
        "calendar",
        "list.bullet",
        "person"
    ]
    
    @State var searchText: String
    
    var body: some View {
        VStack{
                ZStack{
                switch selectedIndex {
                case 0:
                    VStack {
                        Text("Feed").padding()
                        Spacer()
                    }
                    .navigationTitle("Feed")
                case 1:
                    VStack {
                        Text("Map View")
                        Spacer()
                    }
                    .navigationTitle("Map View")
                    
                case 2:
                    VStack {
                        SearchBar(text1: $searchText)
                        List(places.filter({ searchText.isEmpty ? true : $0.eventName.contains(searchText) })) { item in
                            Text(item.eventName)}
                        Spacer()
                    }
                    .navigationTitle("Your Events")
                    
                case 3:
                    VStack {
                        SearchBar(text1: $searchText)

                        //List no longer opens up for now but the filter works :)
                        List(places.filter({ searchText.isEmpty ? true : $0.eventName.contains(searchText) })) { item in
                            Text(item.eventName)}
                        Spacer()
                    }
                    .navigationTitle("Events")
                default:
                    VStack {
                        Text("Profile")
                        Spacer()
                    }
                    .navigationTitle("Profile")
                    
                }
            }
            HStack{
                ForEach(0..<5, id: \.self) { number in
                    Spacer()
                    Button(action: {
                        self.selectedIndex = number
                    }, label: {
                        Image(systemName: icons[number])
                            .font(.system(
                                    size: 25,
                                    weight: .regular,
                                    design: .default))
                            .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                    })
                    Spacer()
                }
            }
        }
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
        }.padding(.vertical).frame(width: /*@START_MENU_TOKEN@*/350.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
    }
}

struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView(places: Place.samples(), searchText: "")
    }
}
