
import Foundation
import CoreData

extension Subscription {
    /*
    class func fromFeedlySubscription(subscription: FeedlySubscription) -> Subscription {
    
    var newSubscription = Subscription()
    newSubscription.id = subscription.id
    newSubscription.title = subscription.title
    newSubscription.website = subscription.website
    
    var newCategories = NSMutableSet()
    
    for category in subscription.categories {
    var newCategory = Category.fromFeedlyCategory(category)
    newCategories.addObject(newCategory)
    }
    newSubscription.categories = newCategories
    
    return newSubscription
    }
    */
    
    class func addOrUpdate(subscription: FeedlySubscription, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        var fetchRequest = NSFetchRequest(entityName: "Subscription")
        fetchRequest.predicate = NSPredicate(format: "id=%@", subscription.id)
        
        var fetchError: NSError? = nil
        var matches = context.executeFetchRequest(fetchRequest, error: &fetchError)
        
        if fetchError != nil && error != nil {
            error.memory = fetchError
            
            return
        }
        
        if (matches == nil || matches?.count == 0) {
            
            var newSubscription = NSEntityDescription.insertNewObjectForEntityForName("Subscription", inManagedObjectContext: context) as Subscription
            newSubscription.id = subscription.id
            newSubscription.title = subscription.title
            newSubscription.website = subscription.website
            
            var categories = NSMutableSet()
            for category in subscription.categories {
                categories.addObject(Category.fromFeedlyCategory(category))
            }
            newSubscription.categories = categories
        } else {
            var existingSubscription = matches?.last as Subscription;
            
            existingSubscription.title = subscription.title
            existingSubscription.website = subscription.website
            
            var categories = NSMutableSet()
            for category in subscription.categories {
                categories.addObject(Category.fromFeedlyCategory(category))
            }
            
            existingSubscription.categories = categories
        }
        
        var saveError: NSError? = nil
        context.save(&saveError)
        
        if saveError != nil && error != nil {
            error.memory = saveError
        }
        //else {
        //
        //}
        
        //for category in subscription.categories {
        //    Category.getOrAdd(category, inManagedObjectContext: context, error: error)
        //}
        //else {
        //return matches?.last as Subscription;
        //}
    }
    
    class func beginDownloadLogosAndSave(subscription: Subscription, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
        
    }
}