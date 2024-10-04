//
//  ContentView.swift
//  SailingIndicator
//
//  Created by Gi Woo Kim on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var sailingDataCollector = SailingDataCollector()
    var body: some View {
        ScrollView{
            VStack {
                CompassView().environmentObject(locationManager)
                
         
                MapView().environmentObject(locationManager).padding()
                    .offset(x:0, y: 450)

            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
