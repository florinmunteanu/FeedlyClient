
import Foundation
import CoreData

@objc(Entry)
class Entry: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var published: NSTimeInterval
    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var textSummary: String
    @NSManaged var thumbnail: NSData
    @NSManaged var unread: Bool
    @NSManaged var visual: EntryVisual
    @NSManaged var content: EntryContent
    @NSManaged var summary: EntryContent
    @NSManaged var categories: NSSet

}
