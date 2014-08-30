
import Foundation

class EntryLink {
    
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
    
    class func fromJsonArray(jsonArray: [Dictionary<String, String>]) -> [EntryLink] {
        var entries = Array<EntryLink>()
        
        for json in jsonArray {
            entries.append(EntryLink(json: json))
        }
        return entries
    }
}