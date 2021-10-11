//
//  item.swift
//  iPet
//
//  Created by Mark Lai on 17/9/2021.
//

import Foundation
import SwiftUI

struct Items: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var type: String
    var volume: Int
    var volumeType: String
    var description: String
    var category:String
    var amount: Double
}
