
import Foundation
import CoreData

extension Subscription {
    
    /// Adds a new subscription or updates an existing one.
    ///
    internal class func addOrUpdate(feedlySubscription: FeedlySubscription, inManagedObjectContext context: NSManagedObjectContext) throws {
        
        let fetchRequest = NSFetchRequest(entityName: "Subscription")
        fetchRequest.predicate = NSPredicate(format: "id=%@", feedlySubscription.id)
        
        let matches = try context.executeFetchRequest(fetchRequest)
        
        if (matches.count == 0) {
            try self.insertNewSubscription(feedlySubscription, inManagedObjectContext: context)
        } else {
            let existingSubscription = matches.last as! Subscription;
            try self.updateExistingSubscription(existingSubscription, withFeedlySubscription: feedlySubscription, inManagedObjectContext: context)
        }
        
        try context.save()
    }
    
    private class func insertNewSubscription(feedlySubscription: FeedlySubscription, inManagedObjectContext context: NSManagedObjectContext) throws {
        
        let newSubscription = NSEntityDescription.insertNewObjectForEntityForName("Subscription", inManagedObjectContext: context) as! Subscription
        newSubscription.id = feedlySubscription.id
        newSubscription.title = feedlySubscription.title
        newSubscription.website = feedlySubscription.website
        
        newSubscription.categories = try self.mergeCategories(feedlySubscription, forSubscription: newSubscription, inManagedObjectContext: context)
    }
    
    private class func updateExistingSubscription(existingSubscription: Subscription, withFeedlySubscription feedlySubscription: FeedlySubscription, inManagedObjectContext context: NSManagedObjectContext) throws {
        
        existingSubscription.title = feedlySubscription.title
        existingSubscription.website = feedlySubscription.website
        
        existingSubscription.categories = try self.mergeCategories(feedlySubscription, forSubscription: existingSubscription, inManagedObjectContext: context)
    }
    
    private class func mergeCategories(feedlySubscription: FeedlySubscription, forSubscription subscription: Subscription, inManagedObjectContext context: NSManagedObjectContext) throws -> NSSet {
        
        let categories = NSMutableSet()
        for category in feedlySubscription.categories {
            let category = try Category.getOrAdd(category, inManagedObjectContext: context)
            
            if category != nil {
                categories.addObject(category!)
            }
        }
        return categories
    }
    
    class func beginDownloadLogosAndSave(subscription: Subscription, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
    }
}