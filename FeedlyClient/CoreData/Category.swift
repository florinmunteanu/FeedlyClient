
import Foundation
import CoreData

@objc(Category)
class Category: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var label: String
    @NSManaged var subscriptions: NSSet
    @NSManaged var entries: NSSet
}
