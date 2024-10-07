//
//  ContentView.swift
//  SailingIndicator
//
//  Created by Gi Woo Kim on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var sailingDataCollector = SailingDataCollector()
    @StateObject var windDetector = WindDetector()
    @StateObject var apparentWind = ApparentWind()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack{
                CompassView()
                    .environmentObject(locationManager)
                    .environmentObject(windDetector)
                    .environmentObject(apparentWind)
                
            }
            
            VStack{
                MapView()
                    .environmentObject(sailingDataCollector)
                    .environmentObject(locationManager)
                    .offset(x:0, y: 320)
                
            }
            VStack {
                
                
                VStack(alignment: .center) {
                    if locationManager.speed >= 0 {
                        Text("Speed: \(locationManager.speed, specifier: "%.2f") m/s")
                        .font(.caption2)}
                    else {
                        Text("Getting speed...")
                            .font(.caption2)
                    }
                    if locationManager.course >= 0 {
                        Text("Course: \(locationManager.course, specifier: "%.2f")º")
                            .font(.caption2)
                    }
                    else {
                        Text("Getting course...")
                            .font(.caption2)
                    }
                    
                    if let heading = locationManager.heading {
                        Text("Heading: m:\(heading.magneticHeading, specifier: "%.2f")º t:\(heading.trueHeading, specifier: "%.2f")º")
                            .font(.caption2)
                    } else {
                        Text("Getting Heading...")
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
                        Text("Getting location...")
                            .font(.caption2)
                    }
                }
                
            }
            
            .alert(isPresented: $locationManager.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Location services are disabled."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .offset(y:320)
            
            
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
