//
//  ItemRow.swift
//  iPet
//
//  Created by Mark Lai on 18/9/2021.
//

import SwiftUI

struct ItemRow: View {
    var item:Items
    var body: some View {
        HStack {
            Image(item.image)
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(5)
            VStack {
                Text(item.name)
                    .contentTextStyle()
                Text("Type: \(item.type)")
                    .contentTextStyle()
                Text("Category: \(item.category)")
                    .contentTextStyle()
            }
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
  //  var item:Items
    static let item = Items(name: "Momi Grass (M)", image: "momi_m", type: "Rabbit", volume: 500, volumeType: "gram", description: "Grass for Rabbit", category: "Food", amount: 50)
    
    static var previews: some View {
         
        ItemRow(item: item)
    }
}
