
import Foundation
import CoreData

extension Category {
    
    class func fromFeedlyCategory(category: FeedlyCategory) -> Category {
        var newCategory = Category()
        newCategory.id = category.id
        newCategory.label = category.label
        
        return newCategory
    }
    
    class func getOrAdd(category: FeedlyCategory, inManagedObjectContext context: NSManagedObjectContext, error: NSErrorPointer) {
            
            var fetchRequest = NSFetchRequest(entityName: "Category")
            fetchRequest.predicate = NSPredicate(format: " id = %@", category.id)
            
            var fetchError: NSError? = nil
            var matches = context.executeFetchRequest(fetchRequest, error: &fetchError)
            
            if fetchError != nil && error != nil {
                error.memory = fetchError
            }
            else if (matches == nil || matches?.count == 0) {
                
                var newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as Category
                newCategory.id = category.id
                newCategory.label = category.label
                
                var saveError: NSError? = nil
                context.save(&saveError)
                
                if saveError != nil && error != nil {
                    error.memory = saveError
                }
                //return newCategory
            }
            else {
                //return matches?.last as Category;
            }
    }
}