
import Foundation
import CoreData

@objc(EntryContent)
class EntryContent: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var direction: String
    @NSManaged var entry: Entry

}
