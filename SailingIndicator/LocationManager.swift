//
//  Untitled.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/4/24.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager() // Singleton instance
    var locationManager = CLLocationManager()
    
    @Published var speed: CLLocationSpeed = 0.0 // 속도 (m/s)
    @Published var course: CLLocationDirection = 0.0 // 이동 방향 (degrees)
    @Published var heading: CLHeading? // 나침반 헤딩 정보
    @Published var latitude: CLLocationDegrees = 0.0
    @Published var longitude: CLLocationDegrees = 0.0
    @Published var showAlert : Bool = false
    @Published var  lastLocation: CLLocation?

    let distanceFilter = 5.0
    let headingFilter  = 1.0
    
        
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = distanceFilter
        locationManager.headingFilter = headingFilter
    
        // locationSericeEnable 체크는 필요없나???
        checkAuthorizationStatus()
       
    }
    
    func checkAuthorizationStatus() {
        switch locationManager.authorizationStatus  {
                
        case .authorizedWhenInUse , .authorizedAlways :
                print("authorizedWhenInUse or authorizedAlways ")
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingHeading()
            
            case .denied, .restricted:
                print("denied or restricted")
            case .notDetermined:
                print("notDetermined. requestWhenInUseAuthorization")
                locationManager.requestWhenInUseAuthorization()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.checkAuthorizationStatus() // 권한 요청 후
                }
            default:
                return
            }
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                // 계산의 편의상  속도가 1m/sec 이하면 1이라고 라고 가정했음..
                // location.course 가 값을 갖지 않는경우는 추후라도  location.heading 값으로 대체할것임.
                self.speed = location.speed <= 4 ? 4 : location.speed
                self.course = location.course
                self.latitude = location.coordinate.latitude
                self.longitude  = location.coordinate.longitude
                self.lastLocation = location
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

            switch manager.authorizationStatus {
            case .authorizedWhenInUse , .authorizedAlways:
                manager.startUpdatingLocation()
                manager.startUpdatingHeading()
                showAlert = false
            case .denied, .restricted:
               showAlert = true
                print("denied")
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                showAlert = false
            default:
                showAlert = false
                return
            }
        }
    
}
