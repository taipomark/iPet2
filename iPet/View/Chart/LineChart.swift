//
//  LineChart.swift
//  iPet
//
//  Created by Mark Lai on 2/10/2021.
//

import SwiftUI

struct LineChart: View {
    var data: [(Double)]
    var title: String?
    var price: String?
    var color: Color

    public init(data: [Double],
                title: String? = nil,
                price: String? = nil,
                color: Color) {
            
        self.data = data
        self.title = title
        self.price = price
        self.color = color
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                Group{
                    if (self.title != nil){
                        Text(self.title!)
                            .font(.title)
                    }
                    if (self.price != nil){
                        Text(self.price!)
                            .font(.body)
                        .offset(x: 5, y: 0)
                    }
                }.offset(x: 0, y: 0)
                ZStack{
                    GeometryReader{ reader in
                        Line(data: self.data,
                             frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height)),color:self.color
                            )
                                .offset(x: 0, y: 0)
                        }
                        .frame(width: geometry.frame(in: .local).size.width, height: 200)
                        .offset(x: 0, y: -100)

                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 200)
                
                }
            }

    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(data:[2.3,2.4,2.7,2.6,3.0,2.8], title: "Kim", price: "Test", color: Color.darkYellow)
    }
}

struct Line: View {
    var data: [(Double)]
    @Binding var frame: CGRect
    var color: Color
    @State private var isLoading = false

    let padding:CGFloat = 30
    
    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data
        if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        }else {
            return 0
        }
        if let min = min, let max = max, min != max {
            if (min <= 0){
                return (frame.size.height-padding) / CGFloat(max - min)
            }else{
                return (frame.size.height-padding) / CGFloat(max + min)
            }
        }
        
        return 0
    }
    var path: Path {
        let points = self.data
        return Path.lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
        
    }
    
    public var body: some View {
        
        ZStack {

            self.path
                .trim(to: isLoading ? 1 : 0)
                .stroke(color ,style: StrokeStyle(lineWidth: 3, lineJoin: .round))
         //       path.trim(to: isLoading ? 1 : 0)
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
        }
        .onAppear(){
            withAnimation(.easeInOut(duration: 1)) {
                self.isLoading.toggle()
            }
        }
    }
}

extension Path {
    
    static func lineChart(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        return path
    }
}
