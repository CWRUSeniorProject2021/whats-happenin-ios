//
//  LocationManager.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/12/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    private var _locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var coordinates: CoordinatePair?
    
    private let encoder = JSONEncoder()
    
    override init() {
        super.init()
        encoder.outputFormatting = .prettyPrinted
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
            currentLocation = loc
            coordinates = locToCoords(loc: loc)
            
            do {
                let jsonData = try encoder.encode(coordinates)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    defaults.set(jsonString, forKey: Keys.Defaults.lastLocation)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func getCurrentLocation() -> CoordinatePair? {
        if (currentLocation == nil || coordinates == nil) {
            guard let lastLoc = defaults.string(forKey: Keys.Defaults.lastLocation) else {
                return nil
            }
            if let jsonData = lastLoc.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    coordinates = try decoder.decode(CoordinatePair.self, from: jsonData)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
        }
        return coordinates
    }
    
    private func locToCoords(loc: CLLocation) -> CoordinatePair {
        return CoordinatePair(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
    }
}

let locationManager = LocationManager()
