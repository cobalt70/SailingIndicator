//
//  WindDetector.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/6/24.
//
import CoreLocation
import Foundation
import WeatherKit
import SwiftUI


struct Wind{
    var timeStamp : Date
    var direction : Measurement<UnitAngle>
    var speed :  Measurement<UnitSpeed>
    
}


extension Wind : Codable{
    enum CodingKeys: String, CodingKey {
        case timeStamp = "time"
        case direction = "direction"
        case speed = "speed"
    }
}


class WindDetector : ObservableObject{
    
    @Published var currentWind : Wind?
    
    @ObservedObject var locationManager = LocationManager()
    
    init() {
       
        startCollectingWind()
        
    }
    func startCollectingWind() {
        
        let location = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 37.522, longitude: 126.976)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.fetchCurrentWind(for: location)
            
        }
        Timer.publish(every: 60  , on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchCurrentWind(for: location)
            }
    }
    func fetchCurrentWind(for location: CLLocationCoordinate2D) {
        let weatherService = WeatherService.shared
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                let currentWind = weather.currentWeather.wind
                self.currentWind?.timeStamp = Date()
                self.currentWind?.speed = currentWind.speed
                self.currentWind?.direction = currentWind.direction
                
                
                print("Current wind speed: \(currentWind.speed.value) m/s")
                print("Current wind direction: \(currentWind.direction.value)°")
                
            } catch {
                print("Failed to fetch weather: \(error)")
            }
        }
    }
    
    
}
