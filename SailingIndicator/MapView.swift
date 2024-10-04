//
//  Uitled.swift
//  SailingIndicator
//
//  Created by Giwoo Kim on 10/5/24.
//

import SwiftUICore
import CoreLocation
import MapKit
import Combine
import _MapKit_SwiftUI

struct MapView: View {
    @EnvironmentObject private var locationManager : LocationManager
    
    var body: some View {
        // location이 nil일 경우 기본 좌표 설정
        let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
    
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )), showsUserLocation: true)
            .frame(height: 300) 
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                // 사용자의 위치 업데이트 시작
                self.locationManager.locationManager.startUpdatingLocation()
            }
    }
}
