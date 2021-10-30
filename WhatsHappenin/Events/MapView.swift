//
//  MapView.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 10/28/21.
//
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) ->
        MKMapView {
        let mapView = MKMapView()
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
