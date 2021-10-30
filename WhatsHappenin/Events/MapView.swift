//
//  MapView.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 10/28/21.
//
import MapKit
import SwiftUI

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.51271, longitude: -81.60443),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var body: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
    }
//
//    func updateUIView(_ view: MKMapView, context: Context) {
//
//    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
