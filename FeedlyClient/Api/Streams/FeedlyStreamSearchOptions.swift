
import Foundation

class FeedlyStreamSearchOptions {
    
    init() {
        
    }
    
    var accessToken: String?
    
    // Optional integer number of entry ids to return. default is 20. max is 10,000.
    var count: Int16?
    
    // Optional string newest or oldest. default is newest.
    var ranked: String?
    
    // Optional boolean default value is false.
    var unreadOnly: DarwinBoolean?
    
    // Optional long timestamp in ms.
    var newerThan: Int64?
    
    // Optional string a continuation id is used to page through the entry ids.
    var continuation: String?
    
    func toDictionary() -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()
        
        if let count = self.count {
            parameters.updateValue(String(count), forKey: "count")
        }
        if let ranked = self.ranked {
            parameters.updateValue(ranked, forKey: "ranked")
        }
        if let unreadOnly = self.unreadOnly {
            parameters.updateValue(String(unreadOnly), forKey: "unreadOnly")
        }
        if let newerThan = self.newerThan {
            parameters.updateValue(String(newerThan), forKey: "newerThan")
        }
        if let continuation = self.continuation {
            parameters.updateValue(continuation, forKey: "continuation")
        }
        
        return parameters
    }
}