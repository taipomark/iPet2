//
//  PurchaseProportionPie.swift
//  iPet
//
//  Created by Mark Lai on 26/9/2021.
//

import SwiftUI

struct PurchaseProportionPie: View {
    var startAngle: Double
    var endAngle: Double
    var color: Color
    var text: String
    @State private var isLoading = false
    @State private var RealStart = 0.00
    @State private var RealEnd = 0.00
 //   @Binding var isLoading:Bool
    
    private var  midRadians: Double {
        return Double.pi / 2.0 - (Angle(degrees: startAngle) + Angle(degrees:endAngle)).radians / 2.0
    }

    
    var body: some View {
        GeometryReader { geometry in
        
            
            ZStack{
                
                RingShape(startProgress: startAngle, progress: isLoading ? RealEnd:startAngle, thickness: 40)
                    .fill(color)
    
            }
       
        }
        .aspectRatio(1.0, contentMode: .fit)
        .onAppear(){
            
            withAnimation(Animation.easeInOut(duration: 1.0)){
                isLoading.toggle()
                RealEnd = endAngle
                RealStart = startAngle
            }
        }
        
    //    .padding()
    }

}

struct PurchaseProportionPie_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            PurchaseProportionPie(startAngle: 0, endAngle: 125, color: Color.darkBlue, text: "65%")
            PurchaseProportionPie(startAngle: 125, endAngle: 360, color: Color.darkYellow, text: "35%")
        }.padding()
    }
}

struct RingShape: Shape {
    var startProgress: Double = 0.0
    var progress: Double = 0.0
    var thickness: CGFloat = 40.0
  
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0),
                    radius: min(rect.width, rect.height) / 2.0,
                    startAngle: .degrees( startProgress + -90.0),
                    endAngle: .degrees( progress + -90.0),
                    clockwise: false)
        
        return path.strokedPath(.init(lineWidth: thickness))
    }
}

