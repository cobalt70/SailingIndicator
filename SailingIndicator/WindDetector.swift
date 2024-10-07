//
//  WindDetector.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/6/24.
//
import CoreLocation
import Combine
import Foundation
import SwiftUI
import WeatherKit


struct WindData  {
    var wind: Wind
    var timestamp: Date
}




class WindDetector : ObservableObject{

    @ObservedObject var locationManager = LocationManager()
    
    @Published var currentWind: WindData?
    @Published var timestamp :Date?
    @Published var direction: Double?
    @Published var speed: Double?
   
    
        
    var timer: AnyCancellable?
    
    init() {
       
        startCollectingWind()
        
    }
    func startCollectingWind() {
        
        let location = locationManager.lastLocation ?? CLLocation(latitude: 37.522, longitude: 126.976)
        
        timer =  Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { [weak self] in
                    print("Fectching wind in the timer")
                    await self?.fetchCurrentWind(for: location)
                   
                }
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            Task {
                print("Fectching wind in the disptach")
               await self.fetchCurrentWind(for: location)
              
            }
        }
    }
    
    func fetchCurrentWind(for location: CLLocation) async  {
        let weatherService =  WeatherService.shared
        let location = location
        print("--- sombody called fetchCurrentWind from \(weatherService) at \(location) --- over.\n")
        
        Task {
            do {
                //try! await weatherService.weather(for: syracuse)
                
                let weather = try await weatherService.weather(for: location)
            
                let currentWind = weather.currentWeather.wind
                
                // @Published 는  UI와 관련이있으므로 main thread를 사용해서  update 해줘야 한다고 봄.
                DispatchQueue.main.async {
                    
                    self.currentWind?.timestamp = Date.now
                    self.currentWind?.wind = currentWind
                    self.timestamp = Date.now
                    self.direction = currentWind.direction.value
                    self.speed = currentWind.speed.value
                    print("timestamp : \(self.timestamp!)")
                    print("Current wind speed: \(currentWind.speed.value) m/s")
                    print("Current wind direction: \(currentWind.direction.value)°")
                }
                
                
            } catch {
                print("Failed to fetch weather: \(error) \n")
            }
        }
    }
    
}
