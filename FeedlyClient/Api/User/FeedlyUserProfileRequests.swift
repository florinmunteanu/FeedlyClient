
import Foundation

class FeedlyUserProfileRequests {
    
    class func beginGetUserProfile(accessToken: String, success: (FeedlyUserProfile) -> Void, failure: (NSError) -> Void)
        -> NSURLSessionDataTask? {
            
            let url = String(format: Constants.apiURL + "/v3/profile")
            
            // GET https://sandbox.feedly.com/v3/profile
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer = AFHTTPRequestSerializer()
            manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            let task = manager.GET(url,
                parameters: nil,
                progress: nil,
                success: {
                    (task: NSURLSessionDataTask!, responseObject: AnyObject?) -> Void in
                    
                    if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                        let profile = FeedlyUserProfile(json: jsonResult)
                        success(profile)
                        
                    } else {
                        
                        let error = NSError(domain: FeedlyClientError.domain, code: 1100,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect user profile response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "User profile response was not in json format or the json format has changed."])
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