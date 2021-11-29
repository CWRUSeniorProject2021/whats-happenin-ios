//
//  MapView.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 10/28/21.
//
import MapKit
import SwiftUI
import CoreLocation

struct ShowMap: View {
    @ObservedObject private var controller = EventsListController.sharedInstance
    
    @State private var region = MKCoordinateRegion(center: LocationManager.sharedInstance.getCurrentLocation()?.toCLLocationCoordinate() ?? CLLocationCoordinate2D(latitude: 41.51273, longitude: -81.60443), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var body: some View {
        
        let events = groupEvents($controller.nearbyEvents.wrappedValue)
        let coords = Array(events.keys)
        
        Map(coordinateRegion: $region,
            annotationItems: coords
        ) { coord in
            MapAnnotation(coordinate: coord.toCLLocationCoordinate()) {
                PlaceAnnotationView(events: .constant(events[coord]!))
            }
        }
    }
    
    func isEventWithinDistance(from: CoordinatePair, to: CoordinatePair, range: Double) -> Bool{
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)

        let distanceInMeters = to.distance(from: from)

        if (distanceInMeters <= range) {
            return true
        }
        return false
    }

    func groupEvents(_ events: [Event]) -> [CoordinatePair: [Event]] {
        var output = [CoordinatePair: [Event]]()
        var alreadyGroupedEvents = [Event]()
        let filteredEvents = events.filter { event in return event.address.coordinates != nil }
        filteredEvents.forEach { event in
            if (!alreadyGroupedEvents.contains(event)) {
                print(event)
                var toAdd = [Event]()
                
                let eventsToGroup = filteredEvents.filter { fe in
                    return !alreadyGroupedEvents.contains(fe) && isEventWithinDistance(from: event.address.coordinates!, to: fe.address.coordinates!, range: 10)
                }

                eventsToGroup.forEach { fe in
                    alreadyGroupedEvents.append(fe)
                    toAdd.append(fe)
                }
            
                output[event.address.coordinates!] = toAdd
            }
        }
        return output
    }
}

struct PlaceAnnotationView: View {
    @State private var showTitle = true
    
    @Binding var events: [Event]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach($events) { $event in
                        NavigationLink {
                            EventDetailView(event: $event)
                        } label: {
                            Text($event.title.wrappedValue)
                                .font(.callout).bold()
                            
                        }
                    }
                }
            }
            .frame(maxWidth: 200, maxHeight: 200)
            .padding(10)
            .background(.white)
            .cornerRadius(10)
            .opacity(showTitle ? 0 : 1)
            //.offset(x: 0, y: -100)
            
            VStack(spacing: 0) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .offset(x: 0, y: -5)
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    showTitle.toggle()
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach($events) { $event in
                        NavigationLink {
                            EventDetailView(event: $event)
                        } label: {
                            Text($event.title.wrappedValue)
                                .font(.callout).bold()
                            
                        }
                    }
                }
            }
            .frame(maxWidth: 200, maxHeight: 200)
            .padding(10)
            .background(.white)
            .cornerRadius(10)
            .opacity(0)
        }
    }
}

