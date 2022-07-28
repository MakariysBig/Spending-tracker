import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var note: String?
    @NSManaged public var fullAmount: Double
    @NSManaged public var amount: Double

}

extension Transaction : Identifiable {

}
