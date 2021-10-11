//
//  PetCreateModel.swift
//  iPet
//
//  Created by Mark Lai on 12/9/2021.
//

import Foundation
import Combine


class PetCreateViewModel: ObservableObject {
    // Input
    @Published var name = ""
    @Published var type = ""
    @Published var gender = ""
    @Published var birthday = Date()

    // Output
    @Published var isNameLengthValid = false


    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        $name
            .receive(on: RunLoop.main)
            .map { name in
                return name.count >= 4
            }
            .assign(to: \.isNameLengthValid, on: self)
            .store(in: &cancellableSet)

    }
}
