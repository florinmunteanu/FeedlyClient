
import Foundation

// Optional content object the article content. 
// This object typically has two values: “content” for the content itself, and “direction” (“ltr” for left-to-right, “rtl” for right-to-left). 
// The content itself contains sanitized HTML markup.
class EntryContent {
    
    var content: String
    
    var direction: String
}