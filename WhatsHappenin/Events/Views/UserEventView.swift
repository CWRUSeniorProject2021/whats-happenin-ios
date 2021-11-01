//
//  UserEventView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI

let userCreatedEventsControllerInst = UserCreatedEventsController()

struct UserEventView: View {
   @ObservedObject var controller = userCreatedEventsControllerInst
    @State var searchText: String
    
    @State var isRefreshing: Bool = false
    
    var body: some View {
        VStack {
            SearchBar(text1: $searchText)

            //Filter no longer works but list opens :)
            List {
                ForEach(controller.events.indices, id: \.self) { index in
                    NavigationLink(controller.events[index].title, destination: EventInfoView())
                }
            }
            .pullToRefresh(isShowing: $isRefreshing) {
                controller.reloadCreatedEvents()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isRefreshing = false
                }
            }
            .onChange(of: self.isRefreshing) { value in
            }
            Spacer()
            Buttons()
        }
        .navigationBarTitle("Your Events")
        .navigationBarItems(trailing:
                    NavigationLink(destination: CreateEvent()) {
                            Image(systemName: "plus")
                        }
                    )
    }
}

struct UserEventView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventView(searchText: "")
    }
}
