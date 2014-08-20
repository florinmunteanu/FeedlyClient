
import Foundation

class FeedlyCategories {
    func beginGetCategories(accessToken: String, success: ([Category]) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            
            var url = String(format: Constants.apiURL + "/v3/categories")
            
            // GET https://sandbox.feedly.com/v3/categories
            
            var manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFHTTPRequestSerializer()
            manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
            
            manager.responseSerializer = AFJSONResponseSerializer()
            
            var operation = manager.GET(url, parameters: nil,
                success:  {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void  in
                    if let jsonResult = responseObject as? [Dictionary<String, String>] {
                        var categories = Category.fromJson(jsonResult)
                        success(categories)
                    } else {
                        
                        //failure(error)
                    }
                },
                failure: {
                    (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    failure(error)
            })
            return operation
    }
}