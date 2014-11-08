
import Foundation

// Optional visual object an image URL for this entry.
// If present, “url” will contain the image URL, “width” and “height” its dimension, and “contentType” its MIME type.

class FeedlyEntryVisual {
    
    init(json: Dictionary<String, AnyObject>) {
        if let url = json["url"] as AnyObject! as? String {
            self.url = url
        }
        if let width = json["width"] as AnyObject! as? Int {
            self.width = Int32(width)
        }
        if let height = json["height"] as AnyObject! as? Int {
            self.height = Int32(height)
        }
        if let contentType = json["contentType"] as AnyObject! as? String {
            self.contentType = contentType
        }
    }
    
    var url: String = ""
    
    var width: Int32 = 0
    
    var height: Int32 = 0
    
    var contentType: String = ""
}