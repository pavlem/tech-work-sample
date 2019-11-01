//
//  MapKitHelper.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 01/11/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import MapKit

struct MapKitHelper {
    
    struct Region {
        static let latMeters = Double(50000)
        static let lonMeters = Double(50000)
    }
    
    static func getRegion(location: CLLocation) -> MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: MapKitHelper.Region.latMeters, longitudinalMeters: MapKitHelper.Region.lonMeters)
        return region
    }
    
    static func getCoordinatesAndPlacemark(fromGesture gesture: UITapGestureRecognizer, andMapView mapView: MKMapView, userCoordinatesData: @escaping (CLLocationCoordinate2D, CLPlacemark) -> Void) {
        
        let touchPoint = gesture.location(in: mapView)
        let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let userLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                userCoordinatesData(newCoordinate, placemark)
            }
        }
    }
}
