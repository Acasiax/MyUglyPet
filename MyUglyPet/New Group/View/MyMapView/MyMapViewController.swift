//
//  MyMapViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import MapKit
import Kingfisher

class MyMapViewController: UIViewController, MKMapViewDelegate {
    
    var serverPosts: [PostsModel] = [] // 서버에서 가져온 게시글 데이터를 저장할 변수
    let mapView = MKMapView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 서버에서 게시글 가져오기 및 지도에 핀셋 추가
        fetchPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 설정
        mapView.showsUserLocation = true
        mapView.frame = view.bounds
        mapView.delegate = self
        view.addSubview(mapView)
        
        // 위치 권한 요청 및 위치 업데이트 시작
        LocationManager.shared.requestLocationPermission()
        LocationManager.shared.fetchCurrentLocation()
        //updateMapLocation(LocationManager.shared.currentLocation)
        
        // 위치 업데이트 콜백 등록
//        LocationManager.shared.locationUpdateCallback = { [weak self] coordinate in
//            self?.updateMapLocation(coordinate)
//        }
        
        // 확대/축소 버튼 추가
        addZoomButtons()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 위치 업데이트 중지
        // LocationManager.shared.stopUpdatingLocation()
    }

    // 사용자의 현재 위치로 지도 이동
    private func updateMapLocation(_ coordinate: CLLocationCoordinate2D) {
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
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

extension MyMapViewController {
    
    // 게시글 모든 피드 가져오기
    private func fetchPosts() {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.serverPosts = posts
                
                // 서버에서 가져온 게시글을 기반으로 지도에 핀셋 표시
                self?.addPinsToMap()
                
            case .failure(let error):
                print("포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
    
    // 게시글의 위치 정보를 사용해 지도에 핀셋 추가
    private func addPinsToMap() {
        for post in serverPosts {
            // content3과 content4를 Double로 변환
            print("서버에서 받은 이미지 \(post.files ?? [])")
            print("서버에서 받은 위도 \(post.content3 ?? "없음")")
            print("서버에서 받은 경도 \(post.content4 ?? "없음")")
            if let latitudeString = post.content3, let longitudeString = post.content4,
               let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
                
                // CLLocationCoordinate2D 생성
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                // 이미지 URL 생성
                if let imageUrlString = post.files?.first {
                    let fullImageURLString = APIKey.baseURL + "v1/" + imageUrlString
                    print("전체 이미지 URL: \(fullImageURLString)")
                    // 지도에 핀셋 추가
                    addPinToMap(at: coordinate, title: post.title, imageURL: fullImageURLString)
                    print("🧝🏻‍♂️: \(coordinate)")
                } else {
                    // 이미지가 없는 경우
                    addPinToMap(at: coordinate, title: post.title, imageURL: nil)
                }
            }
        }
        
        // 모든 핀셋이 보이도록 지도 범위를 설정
        setMapRegionToFitAllPins()
    }
    
    // 특정 좌표에 핀셋을 추가하는 메서드
    private func addPinToMap(at coordinate: CLLocationCoordinate2D, title: String?, imageURL: String?) {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.imageURL = imageURL // CustomPointAnnotation에 imageURL을 저장
        print("핀셋 추가: \(annotation.coordinate), 타이틀: \(annotation.title ?? "없음"), 이미지 URL: \(annotation.imageURL ?? "없음")")
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - 이미지 로드 함수
    func loadImage(imageView: UIImageView, imageURL: String?) {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            print("잘못된 URL 문자열: \(imageURL ?? "없음")")
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
                print("이미지 로드 성공📩: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("이미지 로드 실패📩: \(error.localizedDescription)")
            }
        }
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
    
    // MKMapViewDelegate 메서드: 핀셋의 뷰를 커스텀
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        // 이미지 뷰 추가 (선택 사항)
        if let customAnnotation = annotation as? CustomPointAnnotation, let imageURL = customAnnotation.imageURL {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            loadImage(imageView: imageView, imageURL: imageURL)
            annotationView?.leftCalloutAccessoryView = imageView
            print("이미지 URL 로드: \(imageURL)")
        }
        
        return annotationView
    }
}

// CustomPointAnnotation 클래스 정의
class CustomPointAnnotation: MKPointAnnotation {
    var imageURL: String?
}
