
import Foundation

class FeedlyCategory {
    
    var id: String = ""
    
    var label: String = ""
    
    var uncategorized = "global.uncategorized"
    
    class func fromJson(json: [Dictionary<String, String>]) -> [FeedlyCategory] {
        var categories = Array<FeedlyCategory>()
        
        for dict in json {
            var category = FeedlyCategory()
            
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