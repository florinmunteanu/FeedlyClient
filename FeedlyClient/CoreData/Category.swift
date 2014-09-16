
import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var label: String
    @NSManaged var subscriptions: NSSet

}
