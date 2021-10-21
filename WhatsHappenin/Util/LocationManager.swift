//
//  LocationManager.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/12/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var _locationManager: CLLocationManager?
    private var location: CLLocation?
    
    override init() {
        super.init()
        setupUserLocation()
    }
    
    private func setupUserLocation() {
        _locationManager = CLLocationManager()
        _locationManager?.requestAlwaysAuthorization()
        _locationManager?.startUpdatingLocation()
        _locationManager?.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            location = loc
        }
    }
    
    public func getCurrentLocation() -> CoordinatePair? {
        if (location == nil) {
            return nil
        }
        return CoordinatePair(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
    }
}

let locationManager = LocationManager()
