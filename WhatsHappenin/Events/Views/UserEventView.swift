//
//  UserEventView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI

struct UserEventView: View {
    
    @ObservedObject var controller = cntlr
    @State var searchText: String
    
    @State var isRefreshing: Bool = false
    var body: some View {
        VStack {
            SearchBar(text1: $searchText)
            List(cntlr.events) { event in
//                        List($controller.events.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) })) { event in
                NavigationLink(event.title, destination: EventInfoView(event: event))}
            .pullToRefresh(isShowing: $isRefreshing) {
                controller.reloadNearbyEvents()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isRefreshing = false
                }
            }
        }
    }
}

struct UserEventView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventView(searchText: "")
    }
}
