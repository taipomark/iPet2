//
//  ItemList.swift
//  iPet
//
//  Created by Mark Lai on 17/9/2021.
//

import SwiftUI

struct ItemList: View {
    @State private var searchText = ""
    
    private var items = [
        Items(name: "Momi Grass", image: "momi", type: "Rabbit", volume: 1, volumeType: "lbs", description: "Grass for Rabbit", category: "Food", amount: 48.50),
        Items(name: "Haymoment Grass", image: "haymoment", type: "Rabbit", volume: 1, volumeType: "lbs", description: "Grass for Rabbit", category: "Food", amount: 60.00),
        Items(name: "SPS Grass", image: "sps_m", type: "Rabbit", volume: 1, volumeType: "lbs", description: "Grass for Rabbit", category: "Food", amount: 70.00),
        Items(name: "HoleHay", image: "holehay", type: "Rabbit", volume: 24, volumeType: "oz", description: "Grass for Rabbit", category: "Food", amount: 98.00),
        Items(name: "OxbowFood", image: "oxbowFood", type: "Rabbit", volume: 5, volumeType: "lbs", description: "Grass for Rabbit", category: "Food", amount: 114.00),
        Items(name: "Dandelion Roots", image: "Dandelion", type: "Rabbit", volume: 150, volumeType: "gram", description: "Snack for Rabbit", category: "Snack", amount: 64.00),
        Items(name: "Papaya Leaf", image: "Papaya", type: "Rabbit", volume: 30, volumeType: "gram", description: "Snack for Rabbit", category: "Snack", amount: 80.00),
        Items(name: "Wooly Pere Boku", image: "Wooly", type: "Rabbit", volume: 300, volumeType: "gram", description: "Snack for Rabbit", category: "Snack", amount: 115.00),
        Items(name: "Boxo", image: "boxo_l", type: "Rabbit", volume: 40, volumeType: "L", description: "Bedding for Rabbit", category: "Bedding", amount: 168.00),
        Items(name: "Puppy & Puppy Pet Sheet", image: "puppy", type: "Rabbit", volume: 25, volumeType: "sheet", description: "Bedding for Rabbit", category: "Bedding", amount: 125.00),
        Items(name: "Rabbit Tent", image: "tent", type: "Rabbit", volume: 1, volumeType: "piece", description: "Toy for Rabbit", category: "Toy", amount: 128.00),
        Items(name: "Kawai Ball", image: "ball", type: "Rabbit", volume: 1, volumeType: "piece", description: "Toy for Rabbit", category: "Toy", amount: 48.00)
    ]


    
    var body: some View {
            
        VStack {
            Text("Item List")
                .font(.system(size: 40, weight: .black, design: .rounded))
            SearchBar(text: $searchText)
                .padding(.top, -10)
            NavigationView {
                List {
                    ForEach(items.filter({searchText.isEmpty ? true : $0.name.contains(searchText)})) { item in
                        NavigationLink(destination: ItemDetail(item: item)) {
                            ItemRow(item: item)
                        }
                    }
                }
                .navigationTitle("")
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList()
    }
}
 


struct ItemHeader: View{
    @Binding var showNewTask:Bool

    var body: some View{
            
        HStack {
            Text("Item List")
                .font(.system(size: 40, weight: .black, design: .rounded))
                
            Spacer()
            
        }
        .padding()

    }
}

