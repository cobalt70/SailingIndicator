//
//  Uitled.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/5/24.
//

import CoreLocation
import MapKit
import SwiftUI

struct MapView: View {
    @EnvironmentObject var vm: SailingDataCollector
  
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.017470189362115, longitude: 129.32224097538742), 
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
    
    @State private var coordinates: [CLLocationCoordinate2D] = [] // State로 변경

   
    @ObservedObject  var locationManager : LocationManager
        
   
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: [.all]){
                MapPolyline(coordinates: coordinates)
                    .stroke(Color.blue, lineWidth: 2)
               
            }
            .onAppear {
                updateCameraPosition(with: locationManager.lastLocation)
                updateCoordinates() // 초기 좌표 업데이트
            }
            .onChange(of: locationManager.lastLocation) { newValue, oldValue in
                if newValue != oldValue {
                    updateCameraPosition(with : newValue) // 카메라 위치 업데이트
                    updateCoordinates() //좌표 업데이트
                }
                print("sailing data array changed : \(coordinates.count)")
            }
            .frame(height: 200)
            .edgesIgnoringSafeArea(.all)
        
        
       
    }

    private func updateCameraPosition(with location : CLLocation? = nil) {
   
            cameraPosition = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 36.017470189362115, longitude: location?.coordinate.longitude ?? 129.32224097538742),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
            
        
     
        print("cameraposition updated : \(cameraPosition)")
    }

    private func updateCoordinates() {
        if !vm.sailingDataArray.isEmpty {
            coordinates.removeAll()
            coordinates = vm.sailingDataArray.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            print("MapView coordinagtes transferred : \(coordinates)")
        } else{
            
            coordinates.removeAll()
            coordinates.append(CLLocationCoordinate2D(latitude: locationManager.lastLocation?.coordinate.latitude ?? 36.017470189362115 , longitude:locationManager.lastLocation?.coordinate.longitude ?? 129.32224097538742))
        }
    }
}
