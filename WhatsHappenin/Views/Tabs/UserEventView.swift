//
//  UserEventView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI
import SwiftUIRefresh

struct UserEventView: View {
    
    @ObservedObject var controller = EventsListController.sharedInstance
    @State private var searchText: String = ""
    @State var isRefreshing: Bool = false
    
    var body: some View {
        //SearchBar(text1: $searchText)
        List($controller.yourEvents) { $event in
            EventRow(event: $event, controller: controller)
        }
        .padding(EdgeInsets(top: 44, leading: 0, bottom: 24, trailing: 0))
        .edgesIgnoringSafeArea(.all)
        .listStyle(PlainListStyle())
        .pullToRefresh(isShowing: $isRefreshing) {
            controller.loadYourEvents()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isRefreshing = false
                            }
        }
        .onChange(of: self.isRefreshing) { value in
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(destination: CreateEvent()) {
                    Image(systemName: "plus")
                }
              }
        }
    }
}

struct UserEventView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventView()
    }
}
