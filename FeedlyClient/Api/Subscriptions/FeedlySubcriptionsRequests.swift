
import Foundation

class FeedlySubscriptionsRequests {
    
    class func beginGetSubscriptions(accessToken: String, success: ([FeedlySubscription]) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            
            let url = Constants.apiURL + "/v3/subscriptions"
            
            // GET https://sandbox.feedly.com/v3/subscriptions
            
            let manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFHTTPRequestSerializer()
            manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            let operation = manager.GET(url, parameters: nil,
                success:  {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    
                    if let jsonResult = responseObject as? [Dictionary<String, AnyObject>] {
                        let subscriptions = FeedlySubscription.fromJsonArray(jsonResult)
                        success(subscriptions)
                    } else {
                        
                        let error = NSError(domain: FeedlyClientError.domain, code: 1300,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect subscriptions response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "Subscriptions response was not in json format or the json format has changed."])
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