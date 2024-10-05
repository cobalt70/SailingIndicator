//
//  ContentView.swift
//  SailingIndicator
//
//  Created by Gi Woo Kim on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject  var locationManager = LocationManager()
    @StateObject  var sailingDataCollector = SailingDataCollector()
    @StateObject var windDetector = WindDetector()
    
    var body: some View {
        ScrollView{
            VStack {
                
                CompassView()
                    .environmentObject(locationManager)
                    .environmentObject(windDetector)
                
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
                    
                    
                    if let windSpeed = windDetector.currentWind?.speed.value {
                       Text("Wind Speed: \(windSpeed, specifier: "%.2f") m/s")
                            .font(.subheadline)
                    }
                    
                    if let windDirection = windDetector.currentWind?.direction.value {
                        Text("Wind Direction: \(windDirection, specifier: "%.2f")º")
                            .font(.subheadline)
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
                    .offset(x:0, y: 380)

            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
