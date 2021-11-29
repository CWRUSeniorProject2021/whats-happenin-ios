//
//  MapView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/28/21.
//

import SwiftUI
import MapKit

struct MyMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
        
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
            let coordinate = CLLocationCoordinate2D(
                latitude: 12.9716, longitude: 77.5946)
            let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            view.setRegion(region, animated: true)
    }
}
