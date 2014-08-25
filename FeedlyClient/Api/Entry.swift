
import Foundation

class Entry {
    init() {
    
    }
    
    // The timestamp, in ms, when this article was published, as reported by the RSS feed (often inaccurate).
    var published: NSDate
    
    // Optional string array a list of keyword strings extracted from the RSS entry.
    var keywords: [String]?
    
    var updated: NSDate
    
    var title: String
    
    var engagement: Int?

    // A list of category objects (“id” and “label”) that the user associated with the feed of this entry. 
    // This value is only returned if an Authorization header is provided.
    var categories: [Category]
    
    // The unique, immutable ID for this particular article.
    var id: String
    
    var engagementRate: Float?
    
    // Optional string the author’s name
    var author: String?
    
    var origin: EntryOrigin
    
    // Optional content object the article content. 
    // This object typically has two values: “content” for the content itself, and “direction” (“ltr” for left-to-right, “rtl” for right-to-left).
    // The content itself contains sanitized HTML markup.
    var content: EntryContent?
    
    //content object the article summary.
    var summary: EntryContent?
    
    // Was this entry read by the user?
    // If an Authorization header is not provided, this will always return false. 
    // If an Authorization header is provided, it will reflect if the user has read this entry or not.
    var unread: Boolean
    
    // The immutable timestamp, in ms, when this article was processed by the feedly Cloud servers.
    var crawled: NSDate
    
    // The article fingerprint. This value might change if the article is updated.
    var fingerprint: String
}