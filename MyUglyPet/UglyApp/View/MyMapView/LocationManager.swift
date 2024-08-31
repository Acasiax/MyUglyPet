//
//  LocationManager.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/26/24.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    var currentLocation: CLLocationCoordinate2D?
    var locationUpdateCallback: ((CLLocationCoordinate2D) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
            case .denied, .restricted, .notDetermined:
                requestLocationPermission()
            @unknown default:
                fatalError("Unhandled case in location authorization status")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            locationUpdateCallback?(location.coordinate)
            locationManager.stopUpdatingLocation() // 위치 업데이트 중지
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}


