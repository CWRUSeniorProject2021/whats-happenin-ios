//
//  MapView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/28/21.
//

import SwiftUI
import MapKit

struct MyMapView: UIViewRepresentable {
    var annotations: [Annotation] = [Annotation]()
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
        let coordinate = CLLocationCoordinate2D(latitude: 41.51273, longitude: -81.60443)
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        view.delegate = context.coordinator
        view.addAnnotations(annotations)
    }

    func makeCoordinator() -> MapViewCoordinator{
         MapViewCoordinator(self)
    }
}

struct MyMapView_Previews: PreviewProvider {
    static var previews: some View {
        MyMapView(annotations: [Annotation.example])
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapViewController: MyMapView
    
    init(_ control: MyMapView) {
        self.mapViewController = control
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        annotationView.canShowCallout = true
        annotationView.image = UIImage(systemName: "mappin")
        return annotationView
    }
}

class Annotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?,
         subtitle: String?,
         coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static var example: Annotation {
        let annotation = Annotation(title: "Da Village", subtitle: "stupid cwru.", coordinate: CLLocationCoordinate2D(latitude: 41.51273, longitude: -81.60443))
            return annotation
    }
}
