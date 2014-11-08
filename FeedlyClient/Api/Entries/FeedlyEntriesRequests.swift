
import Foundation

class FeedlyEntriesRequests {
    
    class func beginGetEntry(entryId: String, accessToken: String?, success: (FeedlyEntry) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            var encodedEntryId = entryId.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            var url = Constants.apiURL + "/v3/entries/" + encodedEntryId!
            
            // GET /v3/entries/:entryId
            
            var manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            if let accessToken = accessToken? {
                manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            }
            
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            var operation = manager.GET(url, parameters: nil,
                success:  {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    
                    if let jsonResult = responseObject as? [Dictionary<String, AnyObject>] {
                        if jsonResult.count == 1 {
                            var entry = FeedlyEntry(json: jsonResult[0])
                            success(entry)
                        } else {
                            var error = NSError(domain: FeedlyClientError.domain, code: 1500,
                                userInfo: [NSLocalizedDescriptionKey: "Received an incorrect entry response with length <> 1.", NSLocalizedFailureReasonErrorKey: "Entry response was of length 1."])
                            failure(error)                        }
                    } else {
                        
                        var error = NSError(domain: FeedlyClientError.domain, code: 1501,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect entry response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "Entry response was not in json format or the json format has changed."])
                        failure(error)
                    }
                },
                failure: {
                    (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    failure(error)
            })
            return operation
    }
    
    class func beginGetEntries(entries: [String], accessToken: String?, success: (Dictionary<String, FeedlyEntry>) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            
            var url = String(format: Constants.apiURL + "/v3/entries/.mget")
            // POST /v3/entries/.mget
            
            var manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer() as AFHTTPRequestSerializer
            
            if let accessToken = accessToken? {
                manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            }
            
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            var operation = manager.POST(url,
                parameters: entries,
                success: {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    
                    if let jsonResult = responseObject as? [Dictionary<String, AnyObject>] {
                        
                        var parsedResult = Dictionary<String, FeedlyEntry>(minimumCapacity: jsonResult.count)
                        for dictionaryEntry in jsonResult {
                            var parsedEntry = FeedlyEntry(json: dictionaryEntry)
                            parsedResult[parsedEntry.id] = parsedEntry
                        }
                        success(parsedResult)
                    } else {
                        var error = NSError(domain: FeedlyClientError.domain, code: 1502,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect entries response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "Entries response was not in json format or the json format has changed."])
                        failure(error)
                    }
                },
                failure: {
                    (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    failure(error)
            })
            
            return operation
    }
}