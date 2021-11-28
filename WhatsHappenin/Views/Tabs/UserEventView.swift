//
//  UserEventView.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 11/27/21.
//

import SwiftUI

struct UserEventView: View {
    var body: some View {
        Home()
    }
}

struct UserEventView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventView()
    }
}

struct Home : View {
    @ObservedObject var controller = EventsListController.sharedInstance
    @State private var searchText: String = ""
    @State var isRefreshing: Bool = false
    @State var index = 1
    
    var body : some View {
        VStack {
            HStack {
                Text("")
                .font(.title)
                .fontWeight(.bold)
            }
            .padding(.horizontal)
            
            // Tab view...
            
            HStack(spacing: 0) {
                Text("Past")
                    .foregroundColor(self.index == 0 ? .white : Color.red.opacity(0.85))
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal,30)
                    .background(Color.red.opacity(self.index == 0 ? 0.7 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation(.default) {
                            self.index = 0
                        }
                    }
                
                Spacer(minLength: 0)
                
                Text("Your Events")
                    .foregroundColor(self.index == 1 ? .white : Color.red.opacity(0.85))
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal,15)
                    .background(Color.red.opacity(self.index == 1 ? 0.7 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation(.default) {
                            self.index = 1
                        }
                    }
                
                Spacer(minLength: 0)
                
                Text("Future")
                    .foregroundColor(self.index == 2 ? .white : Color.red.opacity(0.85))
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal,30)
                    .background(Color.red.opacity(self.index == 2 ? 0.7 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation(.default) {
                            self.index = 2
                        }
                    }
            }
            .background(Color.black.opacity(0.06))
            .clipShape(Capsule())
            .padding(.horizontal)
            .offset(y: -35)

            TabView(selection: self.$index) {
                
                // Past
                VStack {
                    List($controller.pastEvents) { $event in
                        EventRow(event: $event, controller: controller)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
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
                }
                .tag(0)
                
                // Your Events
                VStack {
                    List($controller.yourEvents) { $event in
                        EventRow(event: $event, controller: controller)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
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
                }
                .tag(1)
                
                // Future
                VStack {
                    List($controller.upcomingEvents) { $event in
                        EventRow(event: $event, controller: controller)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
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
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer(minLength: 0)
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
