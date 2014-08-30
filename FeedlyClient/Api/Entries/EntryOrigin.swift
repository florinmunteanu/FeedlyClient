
import Foundation

class EntryOrigin {
    
    init() {
        self.htmlUrl = ""
        self.title = ""
        self.streamId = ""
    }
    
    init(json: Dictionary<String, String>) {
        if let htmlUrl = json["htmlUrl"] as AnyObject! as? String {
            self.htmlUrl = htmlUrl
        }
        if let title = json["title"] as AnyObject! as? String {
            self.title = title
        }
        if let streamId = json["streamId"] as AnyObject! as? String {
            self.streamId = streamId
        }
    }
    
    var htmlUrl: String = ""
    
    var title: String = ""
    
    var streamId: String = ""
}