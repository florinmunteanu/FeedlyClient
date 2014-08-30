
import Foundation

class Subscription {
    
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
            self.categories = Category.fromJson(categories)
        }
    }
    
    var title: String = ""
    
    var categories: [Category] = []
    
    var id: String = ""
    
    var visualUrl: String = ""
    
    var website: String = ""
    
    class func fromJsonArray(json: [Dictionary<String, AnyObject>]) -> [Subscription] {
        var subscriptions: [Subscription] = []
        for entry in json {
            subscriptions.append(Subscription(json: entry))
        }
        
        return subscriptions
    }
}