
import Foundation

func beginGetUserProfile(accessToken: String, success: (UserProfile) -> Void, failure: (NSError) -> Void)
    -> AFHTTPRequestOperation {
        var url = String(format: Constants.apiURL + "/v3/profile")
        
        // GET https://sandbox.feedly.com/v3/profile
    
        var manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
        
        manager.responseSerializer = AFJSONResponseSerializer()
     
        var operation = manager.GET(url, parameters: nil,
            success:  {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void  in
                if let jsonResult = responseObject as? Dictionary<String, String> {
                    
                    var profile = UserProfile(json: jsonResult)
                    success(profile)
                    
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