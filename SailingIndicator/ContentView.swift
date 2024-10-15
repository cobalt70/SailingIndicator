//
//  ContentView.swift
//  SailingIndicator
//
//  Created by Gi Woo Kim on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var windDetector = WindDetector()
    @StateObject var apparentWind = ApparentWind()
    @StateObject var sailAngleFind = SailAngleFind()
    @StateObject var sailingDataCollector = SailingDataCollector()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .center){
                    // Position 좌표계를 설정해서 직접 포지션위치에 보여줌.
                    CompassView()
                        .environmentObject(locationManager)
                        .environmentObject(windDetector)
                        .environmentObject(apparentWind)
                        .environmentObject(sailAngleFind)
                        .frame(width: geometry.size.width * 0.8 , height: geometry.size.width * 0.8)
                        .position(x: geometry.size.width / 2, y: geometry.size.width * 0.8 / 2 )
                        .padding(5)
                    /*
                         Position 좌표계를 설정해서 직접 포지션위치에 보여줌.
                         VStack에서의 좌표 y: 0은 현재 뷰가 그려질 수 있는 새롭게 할당된 공간의 시작점임. 위에 쌓인 공간을빼고시작점이 바로 0이 되는것임.
                     */
                    MapView()
                        .environmentObject(locationManager)
                        .environmentObject(sailingDataCollector)
                        .frame(width: geometry.size.width * 0.8 , height: geometry.size.width * 0.6)
                        .position(x: geometry.size.width / 2 , y: geometry.size.width * 0.6 / 2 )
                        .padding(5)
                    VStack(alignment: .center) {
                        if locationManager.speed >= 0 {
                            Text("boat Speed: \(locationManager.speed, specifier: "%.2f") m/s")
                            .font(.caption2)}
                        else {
                            Text("Boat doesn't move")
                                .font(.caption2)
                        }
                        if locationManager.course >= 0 {
                            Text("Boat course: \(locationManager.course, specifier: "%.2f")º")
                                .font(.caption2)
                        }
                        else {
                            Text("boat doesn't move")
                                .font(.caption2)
                        }
                        
                        if let heading = locationManager.heading {
                            Text("Boat Heading: m:\(heading.magneticHeading, specifier: "%.2f")º t:\(heading.trueHeading, specifier: "%.2f")º")
                                .font(.caption2)
                        } else {
                            Text("Getting Boat Heading...")
                                .font(.caption2)
                        }
                        
                    }
                    VStack(alignment: .center){
                        if let location = locationManager.lastLocation   {
                            
                            if let timestamp = windDetector.timestamp {
                                Text("Timestamp: \(timestamp) at \(location.coordinate.latitude), \(location.coordinate.longitude)")
                                    .font(.caption2)
                            } else {
                                Text("Timestamp: unavaiable at \(location.coordinate.latitude), \(location.coordinate.longitude)")
                                    .font(.caption2)
                            }
                            Text("True Wind direction: \(String(describing: windDetector.direction ?? 0 ))°")
                                .font(.caption2)
                            Text("True Wind speed : \(String(describing: windDetector.speed ?? 0 )) m/s")
                                .font(.caption2)
                            Text("Apparent Wind direction: \(String(describing: apparentWind.direction ?? 0.0 ))°")
                                .font(.caption2)
                            Text("Apparent Wind speed : \(String(describing: apparentWind.speed ?? 0 )) m/s")
                                .font(.caption2)
                            
                            
                        }
                        else {
                            Text("Getting Wind location...")
                                .font(.caption2)
                        }
                    }
                    
                }.alert(isPresented: $locationManager.showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Location services are disabled."),
                        dismissButton: .default(Text("OK"))
                    )
                } .padding(.top, 35)
           }
           
        }
    }
    
}

#Preview {
    ContentView()
}
