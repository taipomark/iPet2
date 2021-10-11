//
//  Pet.swift
//  iPet
//
//  Created by Mark Lai on 12/9/2021.
//

import Foundation
import CoreData
import SwiftUI

public class Pets: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var gender: String
    @NSManaged public var birthday: Date
}


