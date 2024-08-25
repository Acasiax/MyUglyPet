//
//  MyMapViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import MapKit

class MyMapViewController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) // 새싹 영등포 캠퍼스 위치

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        // 지도 설정
        mapView.frame = view.bounds
        mapView.delegate = self
        view.addSubview(mapView)
        
        // 위치 권한 요청 및 위치 업데이트 시작
        LocationManager.shared.requestLocationPermission()
        LocationManager.shared.startUpdatingLocation()
        
        // 위치 업데이트 콜백 등록
        LocationManager.shared.locationUpdateCallback = { [weak self] coordinate in
            self?.updateMapLocation(coordinate)
        }
        
        // 특정 위치에 핀 추가
        addCustomPin()
        
        // 초기 지도 설정: 만약 사용자가 위치를 허용하지 않았을 경우, 새싹 캠퍼스로 기본 위치 설정
        mapView.setRegion(MKCoordinateRegion(center: sesacCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        // 확대/축소 버튼 추가
        addZoomButtons()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 위치 업데이트 중지
        LocationManager.shared.stopUpdatingLocation()
    }

    // 사용자의 현재 위치로 지도 이동
    private func updateMapLocation(_ coordinate: CLLocationCoordinate2D) {
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    // 특정 위치에 커스텀 핀 추가
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = sesacCoordinate
        pin.title = "새싹 영등포캠퍼스"
        pin.subtitle = "전체 3층짜리 건물"
        mapView.addAnnotation(pin)
    }
    
    // 확대/축소 버튼 추가 함수
    private func addZoomButtons() {
        let zoomInButton = UIButton(type: .system)
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        zoomInButton.frame = CGRect(x: view.frame.width - 60, y: view.frame.height - 200, width: 50, height: 50)
        zoomInButton.backgroundColor = .white
        zoomInButton.layer.cornerRadius = 25
        zoomInButton.addTarget(self, action: #selector(zoomInTapped), for: .touchUpInside)
        view.addSubview(zoomInButton)
        
        let zoomOutButton = UIButton(type: .system)
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        zoomOutButton.frame = CGRect(x: view.frame.width - 60, y: view.frame.height - 140, width: 50, height: 50)
        zoomOutButton.backgroundColor = .white
        zoomOutButton.layer.cornerRadius = 25
        zoomOutButton.addTarget(self, action: #selector(zoomOutTapped), for: .touchUpInside)
        view.addSubview(zoomOutButton)
    }
    
    // 확대 버튼 액션
    @objc private func zoomInTapped() {
        var region = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
    }
    
    // 축소 버튼 액션
    @objc private func zoomOutTapped() {
        var region = mapView.region
        region.span.latitudeDelta *= 2.0
        region.span.longitudeDelta *= 2.0
        mapView.setRegion(region, animated: true)
    }
}


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
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted, .notDetermined:
                requestLocationPermission()
            @unknown default:
                fatalError("Unhandled case in location authorization status")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            locationUpdateCallback?(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}


