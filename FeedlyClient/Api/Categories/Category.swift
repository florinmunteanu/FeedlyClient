
import Foundation

class Category {
    
    var id: String = ""
    
    var label: String = ""
    
    var uncategorized = "global.uncategorized"
    
    class func fromJson(json: [Dictionary<String, String>]) -> [Category] {
        var categories = Array<Category>()
        
        for dict in json {
            var category = Category()
            
            for (key, value) in dict {
                if key == "id" {
                    category.id = value
                } else if key == "label" {
                    category.label = value
                }
            }
            categories.append(category)
        }
        return categories
    }
}