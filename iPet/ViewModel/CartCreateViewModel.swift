//
//  CartCreateViewModel.swift
//  iPet
//
//  Created by Mark Lai on 19/9/2021.
//

import Foundation

class CartCreateViewModel: ObservableObject {
    // Input
    @Published var item_name = ""
    @Published var quantity = 0
    @Published var image = ""
    @Published var volume = 0
    @Published var volume_type = ""
    @Published var type = ""
    @Published var category = ""

    
}
