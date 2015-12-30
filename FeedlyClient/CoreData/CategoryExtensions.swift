
import Foundation
import CoreData

extension Category {
    
    /// Get or adds a new category.
    class func getOrAdd(category: FeedlyCategory, inManagedObjectContext context: NSManagedObjectContext) throws -> Category? {
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: " id = %@", category.id)
        
        let matches = try context.executeFetchRequest(fetchRequest)
        
        if matches.count == 0 {
            
            let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as! Category
            newCategory.id = category.id
            newCategory.label = category.label
            
            try context.save()
            
            return newCategory
        }
        else {
            return matches.last as? Category;
        }
    }
    
    class func deleteAllCategories(inManagedObjectContext context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let allCategories = try context.executeFetchRequest(fetchRequest)
        
        for category in allCategories {
            context.deleteObject(category as! NSManagedObject)
        }
        
        try context.save()
    }
}