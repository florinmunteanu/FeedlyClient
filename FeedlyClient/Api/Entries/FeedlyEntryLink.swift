
import Foundation

class FeedlyEntryLink {
    
    init(json: Dictionary<String, String>) {
        if let href = json["href"] as AnyObject! as? String {
            self.href = href
        }
        if let type = json["type"] as AnyObject! as? String {
            self.type = type
        }
    }
    
    var href: String = ""
    
    var type: String = ""
    
    class func fromJsonArray(jsonArray: [Dictionary<String, String>]) -> [FeedlyEntryLink] {
        var entries = Array<FeedlyEntryLink>()
        
        for json in jsonArray {
            entries.append(FeedlyEntryLink(json: json))
        }
        return entries
    }
}