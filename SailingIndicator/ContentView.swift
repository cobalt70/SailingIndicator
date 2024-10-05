//
//  ContentView.swift
//  SailingIndicator
//
//  Created by Gi Woo Kim on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject  var locationManager = LocationManager()
    @StateObject  var sailingDataCollector = SailingDataCollector(locationManager: LocationManager())
    
    var body: some View {
        ScrollView{
            VStack {
                CompassView().environmentObject(locationManager)
                
         
                MapView(locationManager:locationManager).environmentObject(sailingDataCollector)
                    .offset(x:0, y: 450)

            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
