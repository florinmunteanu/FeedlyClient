
import Foundation

class FeedlySubscription {
    
    init(json: Dictionary<String, AnyObject>) {
        if let title = json["title"] as AnyObject! as? String {
            self.title = title
        }
        if let id = json["id"] as AnyObject! as? String {
            self.id = id
        }
        if let visualUrl = json["visualUrl"] as AnyObject! as? String {
            self.visualUrl = visualUrl
        }
        if let website = json["website"] as AnyObject! as? String {
            self.website = website
        }
        if let categories = json["categories"] as AnyObject! as? [Dictionary<String, String>] {
            self.categories = FeedlyCategory.fromJson(categories)
            
            //if self.categories.count == 0 {
            //    self.categories.append(<#T##newElement: FeedlyCategory##FeedlyCategory#>)
            //}
        }
    }
    
    var title: String = ""
    
    var categories: [FeedlyCategory] = []
    
    var id: String = ""
    
    var visualUrl: String = ""
    
    var website: String = ""
    
    class func fromJsonArray(json: [Dictionary<String, AnyObject>]) -> [FeedlySubscription] {
        var subscriptions: [FeedlySubscription] = []
        for entry in json {
            subscriptions.append(FeedlySubscription(json: entry))
        }
        
        return subscriptions
    }
}