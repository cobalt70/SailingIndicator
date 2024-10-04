//
//  Untitled.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/5/24.
//
import Foundation
import SwiftUI
import Combine
import CoreLocation
//HKWorkoutRoute와 중복되겠지만 일단 중복해서 저장하고 HKworkoutRoute의 기능을 파악해나가기로함

struct SailingData {
    var timeStamp: Date
    var windSpeed: Double  // m/s
    var windDirection: Double  //deg
    var boatSpeed: Double  // m/s
    var boatDirection: Double  // deg
    
    var latitude: Double //deg
    var longitude: Double //deg
}

class SailingDataCollector : ObservableObject {
    @Published var sailingDataArray: [SailingData] = []
    @ObservedObject var locationManager =  LocationManager()
    var cancellables: Set<AnyCancellable> = []
    
    init() {
                if CLLocationManager().authorizationStatus == .authorizedAlways || CLLocationManager().authorizationStatus == .authorizedWhenInUse  {
                    print("start collect data")
                    self.startCollectingData()
                } else {
                    print("not authorized to collect data")
                    locationManager.checkAuthorizationStatus()
                }
    }
    
    func startCollectingData() {
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.collectSailingData()
            }
            .store(in: &cancellables)
    }
    func collectSailingData() {
        let currentTime = Date()
        let windSpeed = 7.0
        let windDirection = 50.0
        let boatSpeed =  locationManager.speed
        let boatDirection = locationManager.course
        let latitude = locationManager.latitude
        let longitude = locationManager.longitude
        let sailingData = SailingData(timeStamp: currentTime,
                                      windSpeed: windSpeed,
                                      windDirection: windDirection,
                                      boatSpeed: boatSpeed,
                                      boatDirection: boatDirection, latitude: latitude, longitude: longitude )
        
        sailingDataArray.append(sailingData)
        print(sailingData)
    }
    
    
}
