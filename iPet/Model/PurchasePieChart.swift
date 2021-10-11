//
//  File.swift
//  iPet
//
//  Created by Mark Lai on 26/9/2021.
//

import Foundation
import SwiftUI

struct PurchasePieChart: Identifiable, Hashable {
    var id = UUID()
    var category:String
    var amount: Double
    var color: Color
    var start: Double
    var end: Double
    var Proportion: String
    
  /*  var color2: Color {
        switch category {
        case "elevation":
            return .gray
        case "heartRate":
            return Color(hue: 0, saturation: 0.5, brightness: 0.7)
        case "pace":
            return Color(hue: 0.7, saturation: 0.4, brightness: 0.7)
        default:
            return .black
        }
    }
   */
}

class PurchasePieChartList: ObservableObject {

    @Published var pieChart:[PurchasePieChart] = []

    func getGroups() -> [String] {

        var groups : [String] = []

        for pie in pieChart {
            if !groups.contains(pie.category) {
                groups.append(pie.category)
            }
        }
        return groups
    }
}
