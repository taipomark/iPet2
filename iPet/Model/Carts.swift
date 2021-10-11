//
//  Carts.swift
//  iPet
//
//  Created by Mark Lai on 18/9/2021.
//

import Foundation
import CoreData

public class Carts: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var item_name: String
    @NSManaged public var quantity: Int
    @NSManaged public var image: String
    @NSManaged public var volume: Int
    @NSManaged public var volume_type: String
    @NSManaged public var type: String
    @NSManaged public var category: String
    @NSManaged public var amount: Double
}
