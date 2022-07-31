//
//  Profit+CoreDataProperties.swift
//  PetProject
//
//  Created by User on 31.07.22.
//
//

import Foundation
import CoreData


extension Profit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profit> {
        return NSFetchRequest<Profit>(entityName: "Profit")
    }

    @NSManaged public var income: Double

}

extension Profit : Identifiable {

}
