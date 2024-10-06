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
    
    var body: some View {
        ScrollView{
            CompassView()
                .environmentObject(locationManager)
                .environmentObject(windDetector)
            
            VStack {
                
                
                VStack(alignment: .center) {
                    if locationManager.speed >= 0 {
                        Text("Speed: \(locationManager.speed, specifier: "%.2f") m/s")
                        .font(.subheadline)}
                    else {
                        Text("Getting speed...")
                            .font(.subheadline)
                    }
                    if locationManager.course >= 0 {
                        Text("Course: \(locationManager.course, specifier: "%.2f")º")
                            .font(.subheadline)
                    }
                    else {
                        Text("Getting course...")
                            .font(.subheadline)
                    }
                    
                    if let heading = locationManager.heading {
                        Text("Heading: \(heading.magneticHeading, specifier: "%.2f")º")
                            .font(.subheadline)
                    } else {
                        Text("Getting Heading...")
                            .font(.subheadline)
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
                        Text("Wind direction: \(String(describing: windDetector.direction ?? 0 ))°")
                            .font(.caption2)
                        Text("Wind speed : \(String(describing: windDetector.speed ?? 0 )) m/s")
                            .font(.caption2)
                        
                    }
                    else {
                        Text("Getting location...")
                            .font(.subheadline)
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
            
            MapView()
                .environmentObject(sailingDataCollector)
                .environmentObject(locationManager)
                .offset(x:0, y: 320)
            
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
