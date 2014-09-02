
import Foundation

class FeedlyEntry {
    
    init(json: Dictionary<String, AnyObject>) {
        if let id = json["id"] as AnyObject! as? String {
            self.id = id
        } else {
            self.id = ""
        }
        
        if let publishedDate = json["published"] as AnyObject! as? Double {
            self.published = NSDate(timeIntervalSince1970: publishedDate / 1000)
        } else {
            self.published = NSDate(timeIntervalSince1970: 0.0)
        }
        
        if let updated = json["updated"] as AnyObject! as? Double {
            self.updated = NSDate(timeIntervalSince1970: updated / 1000)
        }
        
        if let title = json["title"] as AnyObject! as? String {
            self.title = title
        } else {
            self.title = ""
        }
        
        if let categories = json["categories"] as AnyObject! as? [Dictionary<String, String>] {
            self.categories = FeedlyCategory.fromJson(categories)
        }
        if let keywords = json["keywords"] as AnyObject! as? [String] {
            self.keywords = keywords
        }
        if let engagement = json["engagement"] as AnyObject! as? Int {
            self.engagement = engagement
        }
        if let engagementRate = json["engagementRate"] as AnyObject! as? Double {
            self.engagementRate = engagementRate
        }
        if let author = json["author"] as AnyObject! as? String {
            self.author = author
        }
        if let origin = json["origin"] as AnyObject! as? Dictionary<String, String> {
            self.origin = FeedlyEntryOrigin(json: origin)
        } else {
            self.origin = FeedlyEntryOrigin()
        }
        if let content = json["content"] as AnyObject! as? Dictionary<String, String> {
            self.content = FeedlyEntryContent(json: content)
        }
        if let summary = json["summary"] as AnyObject! as? Dictionary<String, String> {
            self.summary = FeedlyEntryContent(json: summary)
        }
        
        if let unread = json["unread"] as AnyObject! as? Bool {
            self.unread = unread
        } else {
            self.unread = false
        }
        if let crawled = json["crawled"] as AnyObject! as? Double {
            self.crawled = NSDate(timeIntervalSince1970: crawled / 1000)
        } else {
            self.crawled = NSDate(timeIntervalSince1970: 0.0)
        }
        if let fingerprint = json["fingerprint"] as AnyObject! as? String {
            self.fingerprint = fingerprint
        } else {
            self.fingerprint = ""
        }
        if let enclosure = json["enclosure"] as AnyObject! as? [Dictionary<String, String>] {
            self.enclosure = FeedlyEntryLink.fromJsonArray(enclosure)
        }
        if let alternate = json["alternate"] as AnyObject! as? [Dictionary<String, String>] {
            self.alternate = FeedlyEntryLink.fromJsonArray(alternate)
        }
        if let visual = json["visual"] as AnyObject! as? Dictionary<String, AnyObject> {
            self.visual = FeedlyEntryVisual(json: visual)
        }
    }
    
    // The unique, immutable ID for this particular article.
    var id: String
    
    // Optional string the article’s title. This string does not contain any HTML markup.
    var title: String
    
    // The timestamp, in ms, when this article was published, as reported by the RSS feed (often inaccurate).
    var published: NSDate
    
    // Optional timestamp the timestamp, in ms, when this article was updated, as reported by the RSS feed
    var updated: NSDate?
    
    // Optional integer an indicator of how popular this entry is. 
    // The higher the number, the more readers have read, saved or shared this particular entry.
    var engagement: Int?
    
    // Optional string array a list of keyword strings extracted from the RSS entry.
    var keywords: [String]?

    // A list of category objects (“id” and “label”) that the user associated with the feed of this entry.
    // This value is only returned if an Authorization header is provided.
    var categories: [FeedlyCategory]?
    
    var engagementRate: Double?
    
    // Optional string the author’s name
    var author: String?
    
    // Optional origin object the feed from which this article was crawled. 
    // If present, “streamId” will contain the feed id, “title” will contain the feed title, and “htmlUrl” will contain the feed’s website.
    var origin: FeedlyEntryOrigin
    
    // Optional content object the article content. 
    // This object typically has two values: “content” for the content itself, and “direction” (“ltr” for left-to-right, “rtl” for right-to-left).
    // The content itself contains sanitized HTML markup.
    var content: FeedlyEntryContent?
    
    //content object the article summary.
    var summary: FeedlyEntryContent?
    
    // Was this entry read by the user?
    // If an Authorization header is not provided, this will always return false. 
    // If an Authorization header is provided, it will reflect if the user has read this entry or not.
    var unread: Bool
    
    // The immutable timestamp, in ms, when this article was processed by the feedly Cloud servers.
    var crawled: NSDate
    
    //The article fingerprint. This value might change if the article is updated.
    var fingerprint: String
    
    // Optional link object array a list of media links (videos, images, sound etc) provided by the feed. 
    // Some entries do not have a summary or content, only a collection of media links.
    var enclosure: [FeedlyEntryLink]?
    
    // Optional link object array a list of alternate links for this article. 
    // Each link object contains a media type and a URL. Typically, a single object is present, with a link to the original web page.
    var alternate: [FeedlyEntryLink]?
    
    // Optional visual object an image URL for this entry. 
    // If present, “url” will contain the image URL, “width” and “height” its dimension, and “contentType” its MIME type.
    var visual: FeedlyEntryVisual?
}