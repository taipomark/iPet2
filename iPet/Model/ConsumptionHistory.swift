//
//  ConsumptionHistory.swift
//  iPet
//
//  Created by Mark Lai on 22/9/2021.
//

import Foundation
import CoreData

public class ConsumptionHistory: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var deduction: Int
    @NSManaged public var deductionDate: Date
}
