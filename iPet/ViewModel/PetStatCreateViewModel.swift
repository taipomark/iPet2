//
//  PetStatCreateViewModel.swift
//  iPet
//
//  Created by Mark Lai on 25/9/2021.
//

import Foundation
import Combine


class PetStatCreateViewModel: ObservableObject {
    // Input
    @Published var height = ""
    @Published var length = ""
    @Published var weight = ""
    @Published var measureDate = Date()

    // Output
    @Published var isNameLengthValid = false


    private var cancellableSet: Set<AnyCancellable> = []

    init() {

    }
}
