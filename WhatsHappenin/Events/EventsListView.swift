//
//  EventsListView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 9/19/21.
//

import SwiftUI
import Siesta
import SwiftUIRefresh


let cntlr = EventsListViewController()

struct EventsListView: View {
    @ObservedObject var controller = cntlr
    //@State private var events = controller.events
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
    
    @State var isRefreshing: Bool = false
    
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
                        MapView()
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                    
                    
                case 2:
                    VStack {
                        SearchBar(text1: $searchText)
                        List(cntlr.events) { event in
//                        List($controller.events.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) })) { event in
                            NavigationLink(event.title, destination: EventInfoView())}
                        .pullToRefresh(isShowing: $isRefreshing) {
                            controller.reloadNearbyEvents()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isRefreshing = false
                            }
                        }
                        Spacer()
                    }
                    .navigationTitle("Your Events")
                    
                case 3:
                    VStack {
                        SearchBar(text1: $searchText)

                        //Filter no longer works but list opens :)
                        List {
                            ForEach(cntlr.events.indices, id: \.self) { index in
                                NavigationLink(cntlr.events[index].title, destination: EventInfoView())
                            }
                        }
                        .pullToRefresh(isShowing: $isRefreshing) {
                            controller.reloadNearbyEvents()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isRefreshing = false
                            }
                        }
                        .onChange(of: self.isRefreshing) { value in
                        }
                        Spacer()
                    }
                    .navigationBarTitle("Nearby Events")
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
        }.navigationBarBackButtonHidden(false)
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
    
    private func doNothing() {
        
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

//let controller = EventsListViewController()
//let view : some View = EventsListView(searchText: "").environmentObject(controller) // makes `controller` available to all subviews

