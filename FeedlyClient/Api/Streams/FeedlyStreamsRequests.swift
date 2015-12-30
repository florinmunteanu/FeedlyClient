
import Foundation

class FeedlyStreamsRequests {
    
    // A feedId, a categoryId, a tagId or a system category ids can be used as stream ids.
    //
    class func beginGetStream(streamId: String, options: FeedlyStreamSearchOptions?, success: (FeedlyStream) -> Void, failure: (NSError) -> Void)
        -> NSURLSessionDataTask? {
            
            let encodedStreamId = streamId.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            let url = Constants.apiURL + "/v3/streams/" + encodedStreamId! + "/ids"
            
            // GET /v3/streams/:streamId/ids
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer = AFHTTPRequestSerializer()
            if let accessToken = options?.accessToken {
                manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            }
            var parameters = Dictionary<String, String>()
            if options != nil {
                parameters = options!.toDictionary()
            }
                        
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            let task = manager.GET(url,
                parameters: parameters,
                progress: nil,
                success:  {
                    (task: NSURLSessionDataTask!, responseObject: AnyObject?) -> Void in
                    
                    if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                        let stream = FeedlyStream(json: jsonResult)
                        success(stream)
                    } else {
                        
                        let error = NSError(domain: FeedlyClientError.domain, code: 1400,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect stream response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "Stream response was not in json format or the json format has changed."])
                        failure(error)
                    }
                },
                failure: {
                    (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                    failure(error)
            })
            
            return task
    }
}