//
//  Untitled.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/4/24.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var speed: CLLocationSpeed = 0.0 // 속도 (m/s)
    @Published var course: CLLocationDirection = 0.0 // 이동 방향 (degrees)
    @Published var heading: CLHeading? // 나침반 헤딩 정보

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // 위치 정보 업데이트
        locationManager.startUpdatingHeading()  // 나침반 헤딩 정보 업데이트
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.speed = location.speed
                self.course = location.course
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading
        }
    }
}
