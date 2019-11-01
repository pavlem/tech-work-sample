//
//  LocationEngine.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 01/11/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationEngineProtocol: class {
    func locationFound(location: CLLocation)
}

class LocationEngine: NSObject {
    
    // MARK: - API
    static let shared = LocationEngine()
    
    weak var delegate: LocationEngineProtocol?
    
    func startMonitoringForLocation() {
        guard ReachabilityHelper.isThereInternetConnection else { return }
        monitorForLocations()
    }
    
    // MARK: - Properties
    private var locationManager: CLLocationManager!
    private var foundLocationInfo: CLPlacemark?
    private var foundLocation: CLLocation? {
        willSet {
            guard let location = newValue else { return }
            delegate?.locationFound(location: location)
        }
    }
    
    // MARK: - Helper
    private func monitorForLocations() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationEngine: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0] as CLLocation
        self.foundLocation = userLocation
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                self.foundLocationInfo = placemark
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
