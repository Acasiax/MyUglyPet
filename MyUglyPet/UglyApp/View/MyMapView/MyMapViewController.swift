//
//  MyMapViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import MapKit
import Kingfisher

class MyMapViewController: UIViewController {
    
    // 서버에서 가져온 게시글 데이터를 저장할 변수
    var serverPosts: [PostsModel] = []
    let mapView = MKMapView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 서버에서 게시글 가져오기 및 지도에 핀셋 추가
        fetchPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        requestLocationUpdates()
        addZoomButtons()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 위치 업데이트 중지 (필요 시 활성화)
        // LocationManager.shared.stopUpdatingLocation()
    }

    // MARK: - 지도 설정
    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.frame = view.bounds
        mapView.delegate = self
        view.addSubview(mapView)
    }

    // 위치 권한 요청 및 위치 업데이트 시작
    private func requestLocationUpdates() {
        LocationManager.shared.requestLocationPermission()
        LocationManager.shared.fetchCurrentLocation()

        // 위치 업데이트 콜백 등록 (필요 시 활성화)
        // LocationManager.shared.locationUpdateCallback = { [weak self] coordinate in
        //     self?.updateMapLocation(coordinate)
        // }
    }

    // 사용자의 현재 위치로 지도 이동
    private func updateMapLocation(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: true)
    }
    

}

extension MyMapViewController {
    
    // MARK: - 게시글 가져오기 및 핀셋 추가
    private func fetchPosts() {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.serverPosts = posts
                self?.addPinsToMap()
                
            case .failure(let error):
                print("포스팅을 가져오는데 실패했습니다: \(error.localizedDescription)")
            }
        }
    }
    
    // 게시글의 위치 정보를 사용해 지도에 핀셋 추가
    private func addPinsToMap() {
        for post in serverPosts {
            guard let coordinate = createCoordinate(from: post) else { continue }
            let imageURL = post.files?.first.flatMap { APIKey.baseURL + "v1/" + $0 }
            addPinToMap(at: coordinate, title: post.title, imageURL: imageURL)
        }
        setMapRegionToFitAllPins()
    }
    
    // 좌표 생성
    private func createCoordinate(from post: PostsModel) -> CLLocationCoordinate2D? {
        guard
            let latitudeString = post.content3,
            let longitudeString = post.content4,
            let latitude = Double(latitudeString),
            let longitude = Double(longitudeString)
        else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // 특정 좌표에 핀셋 추가
    private func addPinToMap(at coordinate: CLLocationCoordinate2D, title: String?, imageURL: String?) {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.imageURL = imageURL
        mapView.addAnnotation(annotation)
    }
    
    // 모든 핀셋을 포함하는 지도로 조정
    private func setMapRegionToFitAllPins() {
        var zoomRect = MKMapRect.null
        
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
    
}

// MARK: - MKMapViewDelegate 관련 메서드
extension MyMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let customAnnotation = annotation as? CustomPointAnnotation, let imageURL = customAnnotation.imageURL {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            loadImage(imageView: imageView, imageURL: imageURL)
            annotationView?.leftCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
}


// MARK: - 확대 축소 버튼
extension MyMapViewController {

    private func addZoomButtons() {
        addZoomButton(title: "+", action: #selector(zoomInTapped), position: CGPoint(x: view.frame.width - 60, y: view.frame.height - 200))
        addZoomButton(title: "-", action: #selector(zoomOutTapped), position: CGPoint(x: view.frame.width - 60, y: view.frame.height - 140))
    }
    
    private func addZoomButton(title: String, action: Selector, position: CGPoint) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.frame = CGRect(origin: position, size: CGSize(width: 50, height: 50))
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.addTarget(self, action: action, for: .touchUpInside)
        view.addSubview(button)
    }

    @objc private func zoomInTapped() {
        adjustMapZoom(scale: 0.5)
    }
    
    @objc private func zoomOutTapped() {
        adjustMapZoom(scale: 2.0)
    }
    
    private func adjustMapZoom(scale: Double) {
        var region = mapView.region
        region.span.latitudeDelta *= scale
        region.span.longitudeDelta *= scale
        mapView.setRegion(region, animated: true)
    }
}


// MARK: - 이미지 로드 함수
extension MyMapViewController {
    func loadImage(imageView: UIImageView, imageURL: String?) {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            imageView.image = UIImage(named: "placeholder")
            return
        }

        let headers = Router.fetchPosts(query: FetchReadingPostQuery(next: nil, limit: "10", product_id: "")).headersForImageRequest
        let modifier = AnyModifier { request in
            var r = request
            r.allHTTPHeaderFields = headers
            return r
        }
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.requestModifier(modifier)]
        ) { result in
            switch result {
            case .success(let value):
                print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("이미지 로드 실패: \(error.localizedDescription)")
            }
        }
    }
}



// CustomPointAnnotation 클래스 정의
class CustomPointAnnotation: MKPointAnnotation {
    var imageURL: String?
}

