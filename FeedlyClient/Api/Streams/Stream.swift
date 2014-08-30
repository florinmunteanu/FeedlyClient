
import Foundation

class Stream {
    init(json: Dictionary<String, AnyObject>) {
        if let entries = json["ids"] as AnyObject! as? [String] {
            self.entries = entries
        }
        if let continuation = json["continuation"] as AnyObject! as? String {
            self.continuation = continuation
        }
    }
    
    // string array a list of IDs which can be used with the entries API to retrieve the content.
    var entries: [String] = []
    
    // Optional string the continuation id to pass to the next stream call, for pagination. 
    // This id guarantees that no entry will be duplicated in a stream (meaning, there is no need to de-duplicate entries returned by this call).
    // If this value is not returned, it means the end of the stream has been reached.
    var continuation: String = ""
}
