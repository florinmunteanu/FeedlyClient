
import Foundation

class FeedlyMarkersRequests {
    // failure: (NSError) -> Void
    class func markEntriesAsRead(entryIds: [String], accessToken: String) -> NSURLSessionDataTask? {
        let url = Constants.apiURL + "/v3/markers"
        
        let parameters = [
            "type"     : "entries",
            "action"   : "markAsRead",
            "entryIds" : entryIds
        ]
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer() as AFHTTPRequestSerializer
        manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
        
        manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
        
        let task = manager.POST(url,
            parameters: parameters,
            progress: nil,
            success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject?) -> Void in
            },
            failure: {
                (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                //failure(error)
        })
        
        return task
    }
}