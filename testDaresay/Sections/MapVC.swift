//
//  MapVC.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit
import MapKit

protocol MapVCProtocol: class {
    func coordinateChosen(point: CLLocationCoordinate2D, placemark: CLPlacemark)
    func mapDragged()
}

class MapVC: BaseVC {
    
    // MARK: - API
    weak var delegate: MapVCProtocol?
    
    func setRegionFor(location: CLLocation, animated: Bool) {        
        mapView.setRegion(MapKitHelper.getRegion(location: location), animated: animated)
    }
    
    // MARK: - Properties
    lazy var mapView: MKMapView = MKMapView(frame: .zero)
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
    }
    
    // MARK: - Helper
    private func setMapView() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(findLocation(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    // MARK: - Actions
    @objc private func findLocation(_ gesture: UITapGestureRecognizer) {
        guard ReachabilityHelper.isThereInternetConnection else {
            showNoInternetAlert()
            return
        }
        
        MapKitHelper.getCoordinatesAndPlacemark(fromGesture: gesture, andMapView: self.mapView) { (coordinate, placemark) in
            self.delegate?.coordinateChosen(point: coordinate, placemark: placemark)
        }
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        aprint("didDoubleTap")
    }
}

// MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        delegate?.mapDragged()
    }
}
