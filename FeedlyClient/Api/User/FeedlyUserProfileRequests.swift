
import Foundation

class FeedlyUserProfileRequests {
    
    class func beginGetUserProfile(accessToken: String, success: (FeedlyUserProfile) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            var url = String(format: Constants.apiURL + "/v3/profile")
            
            // GET https://sandbox.feedly.com/v3/profile
            
            var manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFHTTPRequestSerializer()
            manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            var operation = manager.GET(url, parameters: nil,
                success:  {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    
                    if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                        var profile = FeedlyUserProfile(json: jsonResult)
                        success(profile)
                        
                    } else {
                        
                        var error = NSError(domain: FeedlyClientError.domain, code: 1100,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect user profile response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "User profile response was not in json format or the json format has changed."])
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