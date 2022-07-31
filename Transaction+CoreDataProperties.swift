//
//  Transaction+CoreDataProperties.swift
//  PetProject
//
//  Created by User on 31.07.22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var fullAmount: Double
    @NSManaged public var note: String?
    @NSManaged public var income: Double

}

extension Transaction : Identifiable {

}
