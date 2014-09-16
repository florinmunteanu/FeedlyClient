
import Foundation
import CoreData

class Subscription: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var logo: NSData
    @NSManaged var title: String
    @NSManaged var website: String
    @NSManaged var categories: NSSet

}
