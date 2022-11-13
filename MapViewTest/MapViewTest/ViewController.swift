//
//  ViewController.swift
//  MapViewTest
//
//  Created by  sangyeon on 2022/11/13.
//

import UIKit
import CoreLocation     // 위치 정보 받아오기 위함
import MapKit

class ViewController: UIViewController {
    
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    // locationManger를 선언함과 동시에 CLLocationManager 객체 생성
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        // desiredAccuracy는 위치의 정확도를 설정
        // 정확도 높으면 배터리 많이 닳음
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()     // startUpdate를 해야 didUpdateLocation 메서드가 호출됨
        manager.delegate = self
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getLocationUsagePermission()
        setUpMapView()
    }
    
    // 뷰가 화면에서 사라질 때 locationManager가 위치 업데이트를 중단하도록 설정
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    private func setUpMapView() {
        // layout 설정
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        // 어플을 종료하고 다시 실행했을 때 MapKit이 발생할 수 있는 오류를 방지하기 위한 처리
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKStandardMapConfiguration()
        } else {
            mapView.mapType = .standard
        }
        
        // 지도에 내 위치 표시
        mapView.showsUserLocation = true
        // 내 위치 기준으로 지도 움직이도록 설정
        mapView.setUserTrackingMode(.follow, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    /// GPS 권한 설정 여부에 따라 로직 분리
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
    func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}
