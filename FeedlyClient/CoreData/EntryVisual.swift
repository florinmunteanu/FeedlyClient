
import Foundation
import CoreData

@objc(EntryVisual)
class EntryVisual: NSManagedObject {

    @NSManaged var url: String
    @NSManaged var width: Int32
    @NSManaged var height: Int32
    @NSManaged var contentType: String
    @NSManaged var entry: Entry

}
