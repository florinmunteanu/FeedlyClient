
import Foundation
import CoreData

extension Entry {
    
    internal class func addOrUpdate(feedlyEntry: FeedlyEntry, inManagedObjectContext context: NSManagedObjectContext) throws {
        
        let fetchRequest = NSFetchRequest(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "id=%@", feedlyEntry.id)
        
        let matches = try context.executeFetchRequest(fetchRequest)
        
        if matches.count == 0 {
            try self.insertNewEntry(feedlyEntry, inManagedObjectContext: context)
        } else {
            let existingEntry = matches.last as! Entry;
            try self.updateExistingEntry(existingEntry, withFeedlyEntry: feedlyEntry, inManagedObjectContext: context)
        }

        try context.save()
    }
    
    internal class func updateThumbnail(entryId: String, thumbnail: NSData, inManagedObjectContext context: NSManagedObjectContext) throws {
        let entry = try readSingleEntry(entryId, inManagedObjectContext: context)
        entry.thumbnail = thumbnail
        
        try context.save()
    }
    
    internal class func markAsRead(entryId: String, inManagedObjectContext context: NSManagedObjectContext) throws {
        let entry = try readSingleEntry(entryId, inManagedObjectContext: context)
        entry.unread = false
        
        try context.save()
    }
    
    private class func readSingleEntry(entryId: String, inManagedObjectContext context: NSManagedObjectContext) throws -> Entry {
        let fetchRequest = NSFetchRequest(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "id=%@", entryId)
        
        let matches = try context.executeFetchRequest(fetchRequest)
        
        if matches.count == 1 {
            return matches.last as! Entry
        } else if matches.count == 0 {
            throw EntryError.NotFound(entryId: entryId)
        } else {
            throw EntryError.DuplicateFound(entryId: entryId)
        }
    }
    
    private class func insertNewEntry(feedlyEntry: FeedlyEntry, inManagedObjectContext context: NSManagedObjectContext) throws {
        
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: context) as! Entry
        
        newEntry.id = feedlyEntry.id
        newEntry.title = feedlyEntry.title
        newEntry.unread = feedlyEntry.unread
        newEntry.author = feedlyEntry.author ?? ""
        newEntry.published = feedlyEntry.published.timeIntervalSince1970
        newEntry.url = feedlyEntry.origin.htmlUrl
        
        if feedlyEntry.content != nil {
            newEntry.content = NSEntityDescription.insertNewObjectForEntityForName("EntryContent", inManagedObjectContext: context) as! EntryContent
            
            newEntry.content.content = feedlyEntry.content!.content
            newEntry.content.direction = feedlyEntry.content!.direction
        }
        if feedlyEntry.summary != nil {
            newEntry.summary = NSEntityDescription.insertNewObjectForEntityForName("EntryContent", inManagedObjectContext: context) as! EntryContent
            
            newEntry.summary.content = feedlyEntry.summary!.content
            newEntry.summary.direction = feedlyEntry.summary!.direction
            
            let parser = EntrySummaryParser(summaryHtmlContent: newEntry.summary.content)
            newEntry.textSummary = parser.parse()
        }
        if feedlyEntry.visual != nil {
            newEntry.visual = NSEntityDescription.insertNewObjectForEntityForName("EntryVisual", inManagedObjectContext: context) as! EntryVisual
            
            newEntry.visual.url = feedlyEntry.visual!.url
            newEntry.visual.width = feedlyEntry.visual!.width
            newEntry.visual.height = feedlyEntry.visual!.height
            newEntry.visual.contentType = feedlyEntry.visual!.contentType
        }
        
        newEntry.categories = try self.mergeCategories(feedlyEntry, forEntry: newEntry, inManagedObjectContext: context)
    }
    
    private class func updateExistingEntry(existingEntry: Entry, withFeedlyEntry feedlyEntry: FeedlyEntry, inManagedObjectContext context: NSManagedObjectContext) throws {
        
        existingEntry.title = feedlyEntry.title
        existingEntry.unread = feedlyEntry.unread
        existingEntry.author = feedlyEntry.author ?? ""
        existingEntry.published = feedlyEntry.published.timeIntervalSince1970
        
        if existingEntry.content.managedObjectContext != nil {
            context.deleteObject(existingEntry.content)
        }
        if existingEntry.summary.managedObjectContext != nil {
            context.deleteObject(existingEntry.summary)
        }
        if existingEntry.visual.managedObjectContext != nil {
            context.deleteObject(existingEntry.visual)
        }
        
        if feedlyEntry.content != nil {
            existingEntry.content = NSEntityDescription.insertNewObjectForEntityForName("EntryContent", inManagedObjectContext: context) as! EntryContent
            
            existingEntry.content.content = feedlyEntry.content!.content
            existingEntry.content.direction = feedlyEntry.content!.direction
        }
        
        if feedlyEntry.summary != nil {
            existingEntry.summary = NSEntityDescription.insertNewObjectForEntityForName("EntryContent", inManagedObjectContext: context) as! EntryContent
            
            existingEntry.summary.content = feedlyEntry.summary!.content
            existingEntry.summary.direction = feedlyEntry.summary!.direction
            
            let parser = EntrySummaryParser(summaryHtmlContent: existingEntry.summary.content)
            existingEntry.textSummary = parser.parse()
        }
        
        if feedlyEntry.visual != nil {
            existingEntry.visual = NSEntityDescription.insertNewObjectForEntityForName("EntryVisual", inManagedObjectContext: context) as! EntryVisual
            
            existingEntry.visual.url = feedlyEntry.visual!.url
            existingEntry.visual.width = feedlyEntry.visual!.width
            existingEntry.visual.height = feedlyEntry.visual!.height
            existingEntry.visual.contentType = feedlyEntry.visual!.contentType
        }
        
        existingEntry.categories = try self.mergeCategories(feedlyEntry, forEntry: existingEntry, inManagedObjectContext: context)
    }
    
    private class func mergeCategories(feedlyEntry: FeedlyEntry, forEntry entry: Entry, inManagedObjectContext context: NSManagedObjectContext) throws -> NSSet {
        
        let categories = NSMutableSet()
        if feedlyEntry.categories != nil {
            for category in feedlyEntry.categories! {
                
                let category = try Category.getOrAdd(category, inManagedObjectContext: context)

                if category != nil {
                    categories.addObject(category!)
                }
            }
        }
        return categories
    }
}
