
import Foundation

class FeedlyCategoriesRequests {
    
    class func beginGetCategories(accessToken: String, success: ([FeedlyCategory]) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            
            let url = Constants.apiURL + "/v3/categories"
            
            // GET https://sandbox.feedly.com/v3/categories
            
            let manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFHTTPRequestSerializer()
            manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            let operation = manager.GET(url, parameters: nil,
                success:  {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void  in
                    
                    if let jsonResult = responseObject as? [Dictionary<String, String>] {
                        let categories = FeedlyCategory.fromJson(jsonResult)
                        success(categories)
                    } else {
                        
                        let error = NSError(domain: FeedlyClientError.domain, code: 1200,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect categories response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "Categories response was not in json format or the json format has changed."])
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