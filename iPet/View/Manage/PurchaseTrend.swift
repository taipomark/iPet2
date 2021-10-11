//
//  PurchaseTrend.swift
//  iPet
//
//  Created by Mark Lai on 1/10/2021.
//

import SwiftUI

struct PurchaseTrend: View {
    
    @State private var doubledWithLoop = [Double]()
    @State private var realWithLoop = [Double]()
    @State private var label:[String] = []
    @State private var max:Double = 0.95
    @State private var min:Double = 1.05
    @State private var isGraph = false
    
    static let BarDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    @FetchRequest(
      entity: PurchaseHistory.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \PurchaseHistory.name, ascending: true),
      ]
    ) var histories: FetchedResults<PurchaseHistory>
    
    func group(_ result : FetchedResults<PurchaseHistory>)-> [[PurchaseHistory]] {
            
        return  Dictionary(grouping: result){ (element : PurchaseHistory)  in
            PurchaseTrend.BarDateFormat.string(from: element.purchaseDate)
        }.values.sorted() { $0[0].purchaseDate > $1[0].purchaseDate }
            
    }
    
    
    
    private func loadBarChartList() {
        doubledWithLoop.removeAll()
        realWithLoop.removeAll()
        label.removeAll()
        let groupHist = group(histories)
        for x in 0..<groupHist.count {
            label.append(PurchaseTrend.BarDateFormat.string(from: groupHist[x].first?.purchaseDate ?? Date()))
            doubledWithLoop.append(getSum(histories: groupHist[x]))
       //     realWithLoop.append(0.00)
        }
        min = (doubledWithLoop.min() ?? 0) * 0.95
        max = (doubledWithLoop.max() ?? 1) * 1.05
        for x in 0..<groupHist.count {
            realWithLoop.append(min)
        }
        isGraph = true
    }
    
    private func getSum(histories: [PurchaseHistory]) -> Double {
        var Amount:Double = 0.00
        for bar in histories {
            Amount += bar.amount
        }
        return Amount
    }
    
    var body: some View {
        VStack {
            
            Text("Purchase Trend")
        //    Text("\(doubledWithLoop[0])")
            if isGraph {
                BarChart(realData: $realWithLoop, data:$doubledWithLoop, labels:$label, accentColor: .darkYellow, axisColor: .lightBlue, showGrid: true, gridColor: .darkBlue, spacing: 20, minimum: $min, maximum: $max)
            }
            
        }.onAppear(perform: loadBarChartList)
        
    }
}

struct PurchaseTrend_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseTrend()
    }
}
