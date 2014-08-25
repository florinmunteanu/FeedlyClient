
import Foundation

class FeedlyStreams {
    // A feedId, a categoryId, a tagId or a system category ids can be used as stream ids.
    func beginGetStream(streamId: String, options: StreamSearchOptions?, success: (Stream) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            
            var url = String(format: Constants.apiURL + "/v3/streams/" + streamId + "/ids")
            
            // GET /v3/streams/:streamId/ids
            
            var manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFHTTPRequestSerializer()
            if let accessToken = options?.accessToken? {
                manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            }
            var parameters = Dictionary<String, String>()
            if options != nil {
                parameters = options!.toDictionary()
            }
                        
            manager.responseSerializer = AFJSONResponseSerializer()
            
            var operation = manager.GET(url, parameters: parameters,
                success:  {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    
                    if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                        var stream = Stream(json: jsonResult)
                        success(stream)
                    } else {
                        
                        var error = NSError(domain: FeedlyApiError.domain, code: 1400,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect stream response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "Stream response was not in json format or the json format has changed."])
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