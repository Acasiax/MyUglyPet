//
//  MyMapViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import MapKit
import CoreLocation

class MyMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    let mapView = MKMapView()
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) // 새싹 영등포 캠퍼스 위치
    var hasReceivedLocation = false // 위치 업데이트를 한 번만 처리하기 위한 플래그

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 설정
        mapView.frame = view.bounds
        mapView.delegate = self
        view.addSubview(mapView)
        
        // 델리게이트 설정
        locationManager.delegate = self
        // 사용자에게 위치 권한 요청
        getLocationUsagePermission()
        
        // 특정 위치에 핀 추가
        addCustomPin()
        
        // 특정 위치로 이동
        mapView.setRegion(MKCoordinateRegion(center: sesacCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // viewWillAppear가 호출될 때 위치 업데이트 시작
        checkUserLocationServicesAuthorization()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // viewDidDisappear가 호출될 때 위치 업데이트 중지
        locationManager.stopUpdatingLocation()
    }

    // 위치 권한 상태가 변경될 때마다 호출되는 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }

    private func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    private func checkUserLocationServicesAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                // 권한이 있을 때만 위치 업데이트 시작
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
                print("위치 업데이트를 시작합니다.")
            case .denied, .restricted:
                print("위치 접근이 거부되었거나 제한되었습니다.")
                getLocationUsagePermission()
            case .notDetermined:
                print("위치 접근이 아직 결정되지 않았습니다.")
                getLocationUsagePermission()
            @unknown default:
                print("새로운 상태가 도입되었습니다. 이에 대해 처리해야 합니다.")
            }
        } else {
            print("위치 서비스가 활성화되지 않았습니다.")
        }
    }
    
    // 위치가 업데이트될 때 한 번만 위도와 경도를 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, !hasReceivedLocation {
            hasReceivedLocation = true
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
            
            // 사용자의 현재 위치로 지도 이동
            mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            
            // 위치 업데이트 중지
            locationManager.stopUpdatingLocation()
        }
    }
    
    // 위치 업데이트와 관련된 에러를 처리
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // 특정 위치에 커스텀 핀 추가
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = sesacCoordinate
        pin.title = "새싹 영등포캠퍼스"
        pin.subtitle = "전체 3층짜리 건물"
        mapView.addAnnotation(pin)
    }
    
    // 재사용 가능한 어노테이션 뷰 제공
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
            annotationView?.canShowCallout = true
            
            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
            miniButton.tintColor = .blue
            annotationView?.rightCalloutAccessoryView = miniButton
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "Circle")
        return annotationView
    }
}
