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

struct SailingData : Equatable, Identifiable{
    var id: UUID = UUID()
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
//    @ObservedObject var locationManager = LocationManager()// EnvironmentObject를 사용하는것과 어떻게 다르지?? 항상 햇갈림
// 모델 vs 모델 인경우  파라메터로 주입시키고 값을 가져다쓰는 방식을 써봄
//보통 뷰모델일때 @ObservedObject나 @EnvironmentObject를 사용하니까 일단 피함
    var cancellables: Set<AnyCancellable> = []
    
    init(locationManager: LocationManager) {
                if CLLocationManager().authorizationStatus == .authorizedAlways || CLLocationManager().authorizationStatus == .authorizedWhenInUse  {
                    print("start collect data")
                    self.startCollectingData(locationManager: locationManager )
                } else {
                    print("not authorized to collect data")
                    locationManager.checkAuthorizationStatus()
                }
    }
    
    func startCollectingData(locationManager: LocationManager) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  self.collectSailingData(locationManager: locationManager)
            
              }
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.collectSailingData(locationManager: locationManager)
            }
            .store(in: &cancellables)
    }
    func collectSailingData(locationManager: LocationManager) {
        let currentTime = Date()
        let windSpeed = 7.0
        let windDirection = 50.0
        let boatSpeed =  locationManager.speed
        let boatDirection = locationManager.course
        let latitude = locationManager.latitude
        let longitude = locationManager.longitude
        let sailingData = SailingData(id: UUID(),
                                      timeStamp: currentTime,
                                      windSpeed: windSpeed,
                                      windDirection: windDirection,
                                      boatSpeed: boatSpeed,
                                      boatDirection: boatDirection, latitude: latitude, longitude: longitude )
        DispatchQueue.main.async {
        
            self.sailingDataArray.append(sailingData)
            print(sailingData)
        }
     
    }
    
    
}
