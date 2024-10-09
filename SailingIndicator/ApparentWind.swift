//
//  ApparentWindViewModel.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/7/24.
//


import Combine
import Foundation
import SwiftUI


class ApparentWind : ObservableObject {
    static let shared =  ApparentWind()
    
    @Published  var direction: Double? = nil
    @Published  var speed:  Double? = nil
    // 나중에  singleton으로  static 변수 하나만 선언해서  한번 선언되면 그것을 가져오는 식으로 수정..==> Singleton
    // windDetector 안에 locationManager가 있음
    // @ObservedObject var windData = WindDetector()
    let windData = WindDetector.shared
    
    var cancellables: Set<AnyCancellable> = []
    
    init()
    {
        startCollectingData()
        
    }
    func startCollectingData() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//            self.calcApparentWind()
//            
//              }
//        Timer.publish(every: 60, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                self?.calcApparentWind()
//            }
//            .store(in: &cancellables)
//        
        
        Publishers.CombineLatest3(windData.$speed, windData.$direction, windData.locationManager.$heading)
            .sink { [weak self] _ , _ , _  in
                self?.calcApparentWind()
                       }
                       .store(in: &cancellables)
        
        
    }
    
    func calcApparentWind(){
        
        guard let windSpeed = windData.speed,
              let windDirection  = windData.direction  else {
            print("wind Data is not available in calcApparentWind")
            return
        }
        let boatSpeed =  windData.locationManager.speed < 0 ? 0 : windData.locationManager.speed
        
        guard let boatHeading =  windData.locationManager.heading?.trueHeading else { return }
        
        
        
        print("calcApparentWind from windSpeed: \(windSpeed) windDirection \(windDirection)")
        print("calcApparentWind from boatHeading:  \(boatSpeed) boatDirection \(boatHeading)")
        
        var windX : Double {
            let angle = Angle(degrees: 90 - windDirection)
            
            return  windSpeed  * cos( angle.radians )
        }
        
        var windY : Double {
            let angle = Angle(degrees: 90 - windDirection)
            return  windSpeed  * sin(angle.radians)
        }
        
        var boatX : Double {
            let angle = Angle(degrees: 90 - boatHeading)
            return boatSpeed * cos(angle.radians)
        }
        
        var boatY : Double {
            let angle = Angle(degrees: 90 - boatHeading)
            return boatSpeed * sin(angle.radians)
        }
        
        var apparentWindX : Double  {
            return  windX + boatX
        }
        
        var apparentWindY : Double  {
            return  windY + boatY
        }
        
        speed = sqrt(pow(apparentWindX,2) + pow(apparentWindY,2) )
        
        if speed != 0 {
            direction =  calculateThetaY(x: apparentWindX, y: apparentWindY)   // caclcuateTheta from Y axis   atan(x over  y) 임
        } else
        {
            direction = windDirection
              
        }
        print("atan(1,  1) \( atan2( 1, 1) * (180 / Double.pi) )")
        print("atan(1, -1) \( atan2( 1, -1) * (180 / Double.pi) )")
        print("atan(-1, -1) \( atan2( -1, -1) * (180 / Double.pi) )")
        print("atan(-1, 1) \( atan2( -1, 1) * (180 / Double.pi) )")
        
        print("windx \(windX) windy \(windY)")
        print("apparent wind speed \(speed!)")
        print("apparent wind direction d: \(direction!)  s:\(speed!) x: \(apparentWindX) y: \(apparentWindY)")
    }
    
    func calculateThetaY(x: Double, y: Double) -> Double {
        let theta = atan2(x, y) * (180 / .pi) // y축에 대한 각도 계산
        return theta < 0 ? theta + 360 : theta // 음수 각도를 양수로 변환
    }

}


