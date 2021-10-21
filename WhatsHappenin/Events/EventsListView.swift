//
//  EventsListView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 9/19/21.
//

import SwiftUI
import Siesta
import SwiftUIRefresh



struct EventsListView: View {
    @EnvironmentObject var controller: EventsListViewController
    //@State var events: [Event]
    @State private var selection: Set<Event> = []
    @State var selectedIndex = 0
    let icons = [
        "house",
        "map",
        "calendar",
        "list.bullet",
        "person"
    ]
    
    @State var searchText: String
    
    @State private var isShowing = false
    
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
                        List(controller.events) { event in
//                        List($controller.events.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) })) { event in
                            NavigationLink(event.title, destination: EventInfoView())}
                        .pullToRefresh(isShowing: $isShowing) {
                            eventsListViewController.reloadNearbyEvents()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isShowing = false
                            }
                        }
                        Spacer()
                    }
                    .navigationTitle("Your Events")
                    
                case 3:
                    VStack {
                        SearchBar(text1: $searchText)

                        //List no longer opens up for now but the filter works :)
                        List(controller.events) { event in
                            NavigationLink(event.title, destination: EventInfoView())}
                        .pullToRefresh(isShowing: $isShowing) {
                            eventsListViewController.reloadNearbyEvents()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isShowing = false
                            }
                        }
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
        }.navigationBarBackButtonHidden(true)
            .onAppear(perform: {
                //whAPI.events.addObserver(self)
                //whAPI.events.loadIfNeeded()
            })
    }
    
//    var list: some View {
//        List($controller.events) { $event in
//            EventView(event: $event, isExpanded: self.selection.contains($event))
//                .onTapGesture { self.selectDeselect($event) }
//
//                .animation(.linear(duration: 0.3))
//        }
//        .pullToRefresh(isShowing: $isShowing) {
//            eventsListViewController.reloadNearbyEvents()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.isShowing = false
//            }
//        }
//
////        .refreshable {
////            await eventsListViewController.reloadNearbyEvents()
////        }
//    }
    
//    var scrollForEach: some View {
//        ScrollView {
//            ForEach($controller.events) { $event in
//                EventView(event: $event, isExpanded: self.selection.contains($event))
//                    .modifier(ListRowModifier())
//                    .onTapGesture { self.selectDeselect($event) }
//                    .animation(.linear(duration: 0.3))
//            }
//        }
//        .pullToRefresh(isShowing: $isShowing) {
//            eventsListViewController.reloadNearbyEvents()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.isShowing = false
//            }
//        }
//    }
    
    private func selectDeselect(_ event: Event) {
        if selection.contains(event) {
            selection.remove(event)
        } else {
            selection.insert(event)
        }
    }
    
}

//extension EventsListView: ResourceObserver {
//    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
//        print("hit resource changed")
//        if let loadedEvents: [Event] = resource.typedContent() {
//            self.events = loadedEvents
//        }
//    }
//}

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            content
            Divider()
        }.padding(.vertical).frame(width: /*@START_MENU_TOKEN@*/350.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView(searchText: "")
    }
}

let controller = EventsListViewController()
let view : some View = EventsListView(searchText: "").environmentObject(controller) // makes `controller` available to all subviews

