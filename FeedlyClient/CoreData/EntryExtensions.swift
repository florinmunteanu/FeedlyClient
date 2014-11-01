
import Foundation
import CoreData

extension Entry {
    
    internal class func addOrUpdate(feedlyEntry: FeedlyEntry, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
        var fetchRequest = NSFetchRequest(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "id=%@", feedlyEntry.id)
        
        var fetchError: NSError? = nil
        var matches = context.executeFetchRequest(fetchRequest, error: &fetchError)
        
        if fetchError != nil && error != nil {
            error.memory = fetchError
            return
        }
        
        if (matches == nil || matches?.count == 0) {
            self.insertNewEntry(feedlyEntry, inManagedObjectContext: context, error: error)
        } else {
            var existingEntry = matches?.last as Entry;
            self.updateExistingEntry(existingEntry, withFeedlyEntry: feedlyEntry, inManagedObjectContext: context, error: error)
        }
        
        var saveError: NSError? = nil
        context.save(&saveError)
        
        if saveError != nil && error != nil {
            error.memory = saveError
        }
    }
    
    private class func insertNewEntry(feedlyEntry: FeedlyEntry, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
        var newEntry = NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: context) as Entry
        newEntry.id = feedlyEntry.id
        newEntry.title = feedlyEntry.title
        newEntry.unread = feedlyEntry.unread
        newEntry.author = feedlyEntry.author ?? ""
        newEntry.published = feedlyEntry.published.timeIntervalSince1970
        
        if feedlyEntry.content != nil {
            newEntry.content = NSEntityDescription.insertNewObjectForEntityForName("EntryContent", inManagedObjectContext: context) as EntryContent
            
            newEntry.content.content = feedlyEntry.content!.content
            newEntry.content.direction = feedlyEntry.content!.direction
        }
        if feedlyEntry.summary != nil {
            newEntry.summary = NSEntityDescription.insertNewObjectForEntityForName("EntryContent", inManagedObjectContext: context) as EntryContent
            
            newEntry.summary.content = feedlyEntry.summary!.content
            newEntry.summary.direction = feedlyEntry.summary!.direction
            
            var parser = EntrySummaryParser(summaryHtmlContent: newEntry.summary.content)
            newEntry.textSummary = parser.parse()
        }
        
        newEntry.categories = self.mergeCategories(feedlyEntry, forEntry: newEntry, inManagedObjectContext: context, error: error)
    }
    
    private class func updateExistingEntry(existingEntry: Entry, withFeedlyEntry feedlyEntry: FeedlyEntry, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
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
        
        if feedlyEntry.content != nil {
            existingEntry.content = NSEntityDescription.insertNewObjectForEntityForName("EntryContent", inManagedObjectContext: context) as EntryContent
            
            existingEntry.content.content = feedlyEntry.content!.content
            existingEntry.content.direction = feedlyEntry.content!.direction
        }
        
        if feedlyEntry.summary != nil {
            existingEntry.summary = NSEntityDescription.insertNewObjectForEntityForName("EntryContent", inManagedObjectContext: context) as EntryContent
            
            existingEntry.summary.content = feedlyEntry.summary!.content
            existingEntry.summary.direction = feedlyEntry.summary!.direction
            
            var parser = EntrySummaryParser(summaryHtmlContent: existingEntry.summary.content)
            existingEntry.textSummary = parser.parse()
        }
        
        existingEntry.categories = self.mergeCategories(feedlyEntry, forEntry: existingEntry, inManagedObjectContext: context, error: error)
    }
    
    private class func mergeCategories(feedlyEntry: FeedlyEntry, forEntry entry: Entry, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) -> NSSet {
        
        var categories = NSMutableSet()
        if feedlyEntry.categories != nil {
            for category in feedlyEntry.categories! {
                
                var categoryError: NSError? = nil
                var category = Category.getOrAdd(category, inManagedObjectContext: context, error: &categoryError)
                
                if categoryError != nil && error != nil {
                    // At first error we encounter, return the current collection
                    error.memory = categoryError
                    return categories
                }
                if category != nil {
                    categories.addObject(category!)
                }
            }
        }
        return categories
    }
}
