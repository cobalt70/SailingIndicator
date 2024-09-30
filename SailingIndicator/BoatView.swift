//
//  BoatView.swift
//  SailingIndicator
//
//  Created by Gi Woo Kim on 9/30/24.
//

import Foundation
import SwiftUI

struct BoatView: View{
    
    var body: some View {
        let lb1 = CGPoint(x: 150, y: 100)
        let lb2 = CGPoint(x : 130, y: 150)
        let lb3 = CGPoint(x: 130, y: 150)
        let lb4 = CGPoint(x : 130, y: 200)
        
        let rb1 = CGPoint(x: 150, y: 100)
        let rb2 = CGPoint(x : 170, y: 150)
        let rb3 = CGPoint(x:  170, y: 150)
        let rb4 = CGPoint(x : 170, y: 200)
        
        
        ZStack {
            
            Path { path in
                path.move(to: lb1)
                path.addCurve(to: lb4, control1: lb2, control2: lb3)
                
            }.stroke(Color.black, lineWidth: 4)
            Path { path in
                path.move(to: rb1)
                path.addCurve(to: rb4, control1: rb2, control2: rb3)
                
            }.stroke(Color.black, lineWidth: 4)

            Path { path in
                let newlb4 = CGPoint(x: lb4.x - 2, y: lb4.y)
                let newrb4 = CGPoint(x: rb4.x + 2, y: rb4.y)

                path.move(to: newlb4)
                path.addLine(to: newrb4)
                
            }.stroke(Color.black, lineWidth: 4)
        }
 }
}


struct BoatView_Previews: PreviewProvider {
    static var previews: some View {
        BoatView()
    }
}
