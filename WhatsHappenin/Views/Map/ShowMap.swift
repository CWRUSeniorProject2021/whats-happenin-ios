//
//  MapView.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 10/28/21.
//
import MapKit
import SwiftUI

struct ShowMap: View {
    @StateObject private var viewModel = ShowMapModel()
    @ObservedObject private var controller = EventsListController.sharedInstance

    var body: some View {
        Map(coordinateRegion: $viewModel.region,
            showsUserLocation: true,
            userTrackingMode: .constant(MapUserTrackingMode.follow),
            annotationItems: controller.nearbyEvents) { event in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.address.coordinates?.latitude ?? 41.51273, longitude: event.address.coordinates?.longitude ?? -81.60443)) {
                            NavigationLink(
                                destination: EventDetailView(event: Binding.constant(event)),
                                label: {
                                    PlaceAnnotationView(title: event.title)

                                })
                        }
            }
            .ignoresSafeArea()
//            .accentColor(Color(.systemPink)) // change current location circle to pink ^_^
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
                viewModel.reload()
                    
            }
    }
//
//    func updateUIView(_ view: MKMapView, context: Context) {
//
//    }
}

struct ShowMap_Previews: PreviewProvider {
    static var previews: some View {
        ShowMap()
    }
}

final class ShowMapModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), // don't need actual loc
                                                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @ObservedObject private var controller = EventsListController.sharedInstance

    
    var locationManager: CLLocationManager?
    
    @State var isRefreshing: Bool = false
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            // Immediately calls locationManagerDidChangeAuth (which will repeatedly check if location on)
            locationManager = CLLocationManager() // Look into if need more features
            locationManager!.delegate = self
        } else {
            print("Show alert letting user know location not enabled")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted, likely due to parental controls ^_^")
        case .denied:
            print("Your location request is denied")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        @unknown default:
            break
        }
    }

    // Check if user turned off location services while the app is open
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func reload() {
        print("Reloading Map")
        controller.loadNearbyEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isRefreshing = false
        }
    }
}

// We can use a custom one in later versions (designed)
struct PlaceAnnotationView: View {
  let title: String

  var body: some View {
    VStack(spacing: 0) {

      Image(systemName: "bell.badge")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .font(.title)
            .foregroundColor(.red)
//
        // Uncomment for standard marker
//        Image(systemName: "mappin.circle.fill")
//          .font(.title)
//          .foregroundColor(.red)
//      Image(systemName: "arrowtriangle.down.fill")
//        .font(.caption)
//        .foregroundColor(.red)
//        .offset(x: 0, y: -5)
    }
  }
}
