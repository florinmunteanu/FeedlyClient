
import Foundation
import CoreData

extension Subscription {
    
    /// Adds a new subscription or updates an existing one.
    ///
    internal class func addOrUpdate(feedlySubscription: FeedlySubscription, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
        var fetchRequest = NSFetchRequest(entityName: "Subscription")
        fetchRequest.predicate = NSPredicate(format: "id=%@", feedlySubscription.id)
        
        var fetchError: NSError? = nil
        var matches = context.executeFetchRequest(fetchRequest, error: &fetchError)
        
        if fetchError != nil && error != nil {
            error.memory = fetchError
            return
        }
        
        if (matches == nil || matches?.count == 0) {
            self.insertNewSubscription(feedlySubscription, inManagedObjectContext: context, error: error)
        } else {
            var existingSubscription = matches?.last as Subscription;
            self.updateExistingSubscription(existingSubscription, withFeedlySubscription: feedlySubscription, inManagedObjectContext: context, error: error)
        }
        
        var saveError: NSError? = nil
        context.save(&saveError)
        
        if saveError != nil && error != nil {
            error.memory = saveError
        }
    }
    
    private class func insertNewSubscription(feedlySubscription: FeedlySubscription, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
        var newSubscription = NSEntityDescription.insertNewObjectForEntityForName("Subscription", inManagedObjectContext: context) as Subscription
        newSubscription.id = feedlySubscription.id
        newSubscription.title = feedlySubscription.title
        newSubscription.website = feedlySubscription.website
        
        newSubscription.categories = self.mergeCategories(feedlySubscription, forSubscription: newSubscription, inManagedObjectContext: context, error: error)
    }
    
    private class func updateExistingSubscription(existingSubscription: Subscription, withFeedlySubscription feedlySubscription: FeedlySubscription, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
        existingSubscription.title = feedlySubscription.title
        existingSubscription.website = feedlySubscription.website
        
        existingSubscription.categories = self.mergeCategories(feedlySubscription, forSubscription: existingSubscription, inManagedObjectContext: context, error: error)
    }
    
    private class func mergeCategories(feedlySubscription: FeedlySubscription, forSubscription subscription: Subscription, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) -> NSSet {
        
        var categories = NSMutableSet()
        for category in feedlySubscription.categories {
            
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
        return categories
    }
    
    class func beginDownloadLogosAndSave(subscription: Subscription, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
    }
}