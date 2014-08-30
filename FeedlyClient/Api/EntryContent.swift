
import Foundation

// Optional content object the article content. 
// This object typically has two values: “content” for the content itself, and “direction” (“ltr” for left-to-right, “rtl” for right-to-left). 
// The content itself contains sanitized HTML markup.
class EntryContent {
    
    init(json: Dictionary<String, String>) {
        if let content = json["content"] as AnyObject! as? String {
            self.content = content
        }
        if let direction = json["direction"] as AnyObject! as? String {
            self.direction = direction
        }
    }
    
    var leftToRight = "ltr"
    
    var rightToLeft = "rtl"
    
    var content: String = ""
    
    var direction: String = ""
}