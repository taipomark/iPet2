//
//  PetStat.swift
//  iPet
//
//  Created by Mark Lai on 22/9/2021.
//

import Foundation
import CoreData

public class PetStat: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var petName: String
    @NSManaged public var height: Double
    @NSManaged public var length: Double
    @NSManaged public var weight: Double
    @NSManaged public var measureDate: Date
}
