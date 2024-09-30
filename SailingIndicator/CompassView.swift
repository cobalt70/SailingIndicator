//
//  CompassView.swift
//  SailingIndicator
//
//  Created by Gi Woo Kim on 9/29/24.
//

import Foundation
import SwiftUI


struct CompassView: View {
 //   @State private var heading: Double = 0 // 현재 방향 (degrees)
    let r1 :   CGFloat =  130
    let r2 :   CGFloat =  150
    let r3 :   CGFloat =  100
    let r4 : CGFloat = 110
    var body: some View {
        ZStack {
            // 나침반 원
            
            Path { path in
                // Arc의 중심 (ZStack에서 중앙을 기준으로)
                let center = CGPoint(x: r2, y: r2)
                let radius: CGFloat = r2
                
                // Arc 추가 (시작 각도와 끝 각도 설정)
                path.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(-90), clockwise: true)
                
            }
            .stroke(Color.green, lineWidth: 4)
            Path { path in
                // Arc의 중심 (ZStack에서 중앙을 기준으로)
                let center = CGPoint(x: r2, y: r2)
                let radius: CGFloat = r2
                
                // Arc 추가 (시작 각도와 끝 각도 설정)
                path.addArc(center: center, radius: radius, startAngle: .degrees(-90), endAngle: .degrees(-180), clockwise: true)
                
            }
            .stroke(Color.red, lineWidth: 4)
            ForEach(0..<360, id: \.self) { degree in
                let isMainDirection = degree % 30 == 0 // 30도마다 큰 눈금
                let lineLength: CGFloat = isMainDirection ? 15 : 5 // 큰 눈금과 작은 눈금의 길이
                let lineColor: Color = isMainDirection ? .black : .orange // 큰 눈금은 검은색, 작은 눈금은 회색
                
                // 선을 그린다
                // 직교 수학 좌표계
                Path { path in
                    // 직교 수학 좌표계
                    let angle = Angle.degrees(Double(degree))
                    let startX = (r1 - lineLength) * cos(angle.radians) // 시작점
                    let startY = (r1 - lineLength) * sin(angle.radians) // 시작점
                    let endX = r2 * cos(angle.radians) // 끝점
                    let endY = r2 * sin(angle.radians) // 끝점
                    
                    let startX1 = startX
                    let endX1 = endX
                    let startY1 = -startY
                    let endY1 = -endY
                    
                    path.move(to: CGPoint(x: startX1, y: startY1))
                    path.addLine(to: CGPoint(x: endX1, y: endY1))
                }   .offset(x: r2, y: r2)
                    .stroke(lineColor, lineWidth: 2)
                
                
            }
            
            
            // 글자 및 방향 표시
            let marks = ["북" , "30" , "60" , "동", "120", "150", "남", "210", "240", "서" ,"300", "330"]
            
            ForEach(0..<marks.count, id: \.self) { index in
                let angle = Angle(degrees: 90 - Double(index) * 30) // 각도 계산
                let x = r3 * cos(angle.radians) // x 좌표
                let y = r3 * sin(angle.radians) // y 좌표
                
                let x_c = r4 * cos(angle.radians)
                let y_c = r4 * sin(angle.radians)
                Path { path in
                    // Arc의 중심 (ZStack에서 중앙을 기준으로)
                    let center = CGPoint(x: x_c, y: -y_c)
                    let radius: CGFloat = 2
                    
                    // Arc 추가 (시작 각도와 끝 각도 설정)
                    path.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
                    
                }
                .offset(x: r2, y: r2)
                .fill(Color.red)
                
                
                Text(marks[index])
                    .rotationEffect(Angle(degrees: Double(index) * 30), anchor: .center)
                    .position(x:r2, y:r2)
                    .offset(x: x, y: -y)
                
                
            }
            
            BoatView()
        }
        
    }
    
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}
