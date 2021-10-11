//
//  BarChart.swift
//  iPet
//
//  Created by Mark Lai on 1/10/2021.
//

import SwiftUI

struct BarChart: View {
  @Binding var realData: [Double]
  @Binding var data: [Double]
  @Binding var labels: [String]
  let accentColor: Color
  let axisColor: Color
  let showGrid: Bool
  let gridColor: Color
  let spacing: CGFloat
  //  private var minimum: Double { (data.min() ?? 0) * 0.95 }
  //  private var maximum: Double { (data.max() ?? 1) * 1.05 }
  @Binding var minimum: Double
  @Binding var maximum: Double
  
  var body: some View {
    VStack {
      ZStack {
        if showGrid {
          BarChartGrid(divisions: 10)
            .stroke(gridColor.opacity(0.2), lineWidth: 0.5)
        }
        
          BarStack(realData: $realData,
                 data: $data,
                 labels: $labels,
                 accentColor: accentColor,
                 gridColor: gridColor,
                 showGrid: showGrid,
                 min: $minimum,
                 max: $maximum,
                 spacing: spacing)
        
        BarChartAxes()
          .stroke(Color.black, lineWidth: 2)
      }
      
        LabelStack(labels: $labels, data:$data, spacing: spacing)
    }
    .padding([.horizontal, .top], 20)
  }
}

struct BarChart_Previews: PreviewProvider {
    //{ (data.min() ?? 0) * 0.95 }
    //{ (data.max() ?? 1) * 1.05 }
    static var previews: some View {
        BarChart(realData:.constant([9.5,9.5,9.5,9.5]),
            data:.constant([10.0, 22.0, 33.0, 20.0]), labels:.constant(["June","July", "Aug", "Sept"]), accentColor: .darkYellow, axisColor: .lightBlue, showGrid: true, gridColor: .darkBlue, spacing: 20, minimum: .constant(10*0.95), maximum: .constant(33 * 1.05))

    }
}


struct BarChartGrid: Shape {
  let divisions: Int
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let stepSize = rect.height / CGFloat(divisions)
    
    (1 ... divisions).forEach { step in
      path.move(to: CGPoint(x: rect.minX, y: rect.maxY - stepSize * CGFloat(step)))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - stepSize * CGFloat(step)))
    }
    
    return path
  }
}

struct BarChartAxes: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    
    return path
  }
}

struct BarStack: View {
    @Binding var realData: [Double]
    @Binding var data: [Double]
    @Binding var labels: [String]
    let accentColor: Color
    let gridColor: Color
    let showGrid: Bool
    @Binding var min: Double
    @Binding var max: Double
    @State private var isLoading = false
    let spacing: CGFloat
    @State private var realMin = 0.95
    @State private var realMax = 1.05
    
  
    var body: some View {
        HStack(alignment: .bottom, spacing: spacing) {
            ForEach(0 ..< data.count) { index in
                ZStack {
                    LinearGradient(
                        gradient: .init(
                            stops: [
                                .init(color: Color.secondary.opacity(0.6), location: 0),
                                .init(color: accentColor.opacity(0.6), location: 0.4),
                                .init(color: accentColor, location: 1)
                            ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
              //    .clipShape(BarPath(data: isLoading ? $data[index]:.constant(-100), min: $min, max: $max))
                        .clipShape(BarPath(data: isLoading ? data[index] : min, min: min, max: max))
                  
                    Text("\($data[index].wrappedValue, specifier: "%.2f")")
                }

            }
        }
        .shadow(color: .black, radius: 5, x: 1, y: 1)
        .padding(.horizontal, spacing)
        .onAppear(){
            withAnimation(Animation.easeInOut(duration: 1.0)){
            isLoading.toggle()
      //      realMax = max
      //      realMin = min
       /*     for x in 0..<data.count {
                realData[x] = data[x]
            }*/
        }
        
        }
    }
}

/*
struct BarPath: Shape {
    @Binding var data: Double
    @Binding var min: Double
    @Binding var max: Double
    @Binding var isLoading:Bool
  
    
  func path(in rect: CGRect) -> Path {
    guard min != max else {
      return Path()
    }
    
    let height = CGFloat((data - min) / (max - min)) * rect.height
    let bar = CGRect(x: rect.minX, y: rect.maxY - (rect.minY + height), width: rect.width, height: height)
    let heightInit = CGFloat(0) * rect.height
      let barInit = CGRect(x: rect.minX, y: rect.maxY - (rect.minY + height), width: rect.width, height: heightInit)
    
      return RoundedRectangle(cornerRadius: 5).path(in: isLoading ? bar:barInit )
          
  }
}
 */

struct BarPath: Shape {
    var data: Double
    var min: Double
    var max: Double

    var animatableData: Double {
        get { data }
        set { data = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        guard min != max else {
            return Path()
    }
    
    let height = CGFloat((data - min) / (max - min)) * rect.height
    let bar = CGRect(x: rect.minX, y: rect.maxY - (rect.minY + height), width: rect.width, height: height)
    
    return RoundedRectangle(cornerRadius: 25).path(in: bar )
          
  }
}

struct LabelStack: View {
  @Binding var labels: [String]
  @Binding var data: [Double]
  let spacing: CGFloat
  
  var body: some View {
    HStack(alignment: .center, spacing: spacing) {
      ForEach(labels, id: \.self) { label in
        Text(label)
          .frame(maxWidth: .infinity)
      }
    }
    .padding(.horizontal, spacing)
  }
}
