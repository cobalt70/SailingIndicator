//
//  SailAngle.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/7/24.
//

import SwiftUI
import Combine
import CoreLocation

enum SailingPoint {
    case closehauled     // 바람을 맞고 항해하는 자세 45도
    case broadReach      // 바람과 거의 옆으로 항해하는 자세 110-140
    case beamReach       // 바람을 옆으로 받아 항해하는 자세 70-110
    case downwind        // 바람을 뒤에서 받으며 항해하는 자세 // 145-180
    case noGoZone        // 못가는 구간 -45~45
    
}

class SailAngleFind: ObservableObject {
    
    // sailAngle은 마스트를 중심으로 오른쪽이 플러스 왼쪽을 마이너스로 정의
    
    @Published  var sailAngle: Double?
    @Published var sailingPoint : [SailingPoint]?
    @ObservedObject var  apparentWind = ApparentWind()
    
    var previousSpeed  : Double = 0
    var previousDirection : Double = 0
    var previousHeading : CLLocationDegrees = 0
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        startCollectingData()
        
    }
    
    func startCollectingData() {
        
        
        Publishers.CombineLatest3( apparentWind.$speed, apparentWind.$direction , apparentWind.windData.locationManager.$heading)
            .filter { [weak self] speed, direction, heading in
                // 이전 값과 비교하여 1도 이상 변했을 때만 필터 통과
                let speedChange = abs((speed ?? 0 - (self?.previousSpeed ?? 0))) > 1
                let directionChange = abs((direction ?? 0 - (self?.previousDirection ?? 0))) > 1
                
                // heading이 nil일 경우에 대한 안전한 처리
                let headingValue = heading?.trueHeading ?? 0.0
                let headingChange = abs(headingValue - (self?.previousHeading ?? 0.0)) > 1
                
                self?.previousSpeed = speed ?? 0
                self?.previousDirection = direction ?? 0
                self?.previousHeading = headingValue
                
                return speedChange || directionChange || headingChange
            }
               .sink { [weak self] _, _, _ in
                   self?.calcSailAngle()
               }
               .store(in: &cancellables)
          
        
    }
    
    
    //0 - 180 : Starboard
    //0 - 180  : Port
    func calcSailAngle(){
        
        guard let windSpeed = apparentWind.speed,
              let windDirection  = apparentWind.direction  else {
            print("wind Data is not available in calcSailAngle")
            return
        }
        print("now windData is available")
        var boatSpeed =  apparentWind.windData.locationManager.speed < 0 ? 0 : apparentWind.windData.locationManager.speed
        
        guard let boatHeading = apparentWind.windData.locationManager.heading?.trueHeading else { return }
        
        if boatHeading < 0 { boatSpeed = 0}
        
        print("calcSailAngle from windSpeed: \(windSpeed) windDirection \(windDirection)")
        print("calcSailAngle from boatSpeed: \(boatSpeed) boatDirection \(boatHeading)")
        
        // 이제 계산 하자
        
        guard let apparentWindDirection = apparentWind.direction else {
            print("apparent wind direction is nil")
        return
        }
        
        let relativeWindDirection =  windDirection - boatHeading
        let relativeApparentWindDirection  = apparentWindDirection  - boatHeading
        
        // 왼쪽방향을 넘어서면 오른쪽 방향에서 계싼
        if relativeWindDirection <  -180 {
            relativeWindDirection  += 360
        }
        // 오른쪽 방향을 넘어가면 왼쪽 방향에서 계산
        
        
        if relativeWindDirection > 180 {
            relativeWindDirection -= 360
        }
    
        
        // 바람이 마이너스 면 세일은 플러스
        // 바람이 플러스 면 세일은 마이넛
        print("relativeWindDirection \(relativeWindDirection)")
        
        
        if relativeWindDirection > -40 && relativeWindDirection < 40 {
            
            print("no go zone")
            sailingPoint = [.noGoZone]
            sailAngle = 0
            
            print("sailAngle between -45 and -130 r:\(relativeWindDirection) s: \(sailAngle)  a: \(relativeApparentWindDirection)")
            
        } else if (relativeWindDirection < -40  && relativeWindDirection > -120) {
            print(".closehauled, .beamReach, .broadReach")
            sailingPoint = [.closehauled, .beamReach, .broadReach]
            sailAngle =  -(relativeApparentWindDirection ?? 0)
            print("sailAngle between -45 and -130 r:\(relativeWindDirection) s: \(sailAngle)  a: \(relativeApparentWindDirection)")
            
            
        } else if (relativeWindDirection > 40  && relativeWindDirection < 120) {
            print(".closehauled, .beamReach, .broadReach")
            sailingPoint = [.closehauled, .beamReach, .broadReach]
            sailAngle = -(relativeApparentWindDirection ?? 0) //check apparentWindDirection 90도 이하인지 체크
            print("sailAngle between 45 and 130 r:\(relativeWindDirection) s: \(sailAngle) a: \(relativeApparentWindDirection)")
        }
        else if relativeWindDirection > 120  {
            // 뒷바람 ..sailAngle은 90도
            print("downWind")
            sailingPoint = [.downwind]
            sailAngle = -90
            print("downWind > 145 SailAngle r:\(relativeWindDirection)  s:\(sailAngle) a:\(relativeApparentWindDirection)")
        }
        else if relativeWindDirection < -120 {
            print("downWind")
            sailingPoint = [.downwind]
            sailAngle = 90
            print("downWind < -145 SailAngle r:\(relativeWindDirection) s:\(sailAngle) a:\(relativeApparentWindDirection)")
        }
        
    }
}
