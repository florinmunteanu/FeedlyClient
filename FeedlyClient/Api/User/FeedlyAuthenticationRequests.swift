
import Foundation

class FeedlyAuthenticationRequests {
    
    class func authenticationUrl() -> String{
        /* Correct URL: http://sandbox.feedly.com/v3/auth/auth?client_id=sandbox&redirect_uri=https%3A%2F%2Flocalhost&scope=https%3A%2F%2Fcloud.feedly.com%2Fsubscriptions&response_type=code */
        
        let queryParameters = [
            FeedlyAuthParameters.responseType : "code",
            FeedlyAuthParameters.clientId     : Constants.clientId,
            FeedlyAuthParameters.redirectUri  : Constants.redirectUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()),
            FeedlyAuthParameters.scope        : Constants.scope.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        ]
        
        var url = String(format: Constants.apiURL + "/v3/auth/auth?")
        
        for (index, entry) in queryParameters.enumerate() {
            url = url.stringByAppendingFormat(index == queryParameters.count - 1 ? "%@=%@" : "%@=%@&", entry.0, entry.1!)
        }
        return url
    }
    
    class func getAuthenticationCode(url: NSURL) -> String {
        // Should receive an url in the form of:
        // https://your.redirect.uri/feedlyCallback?code=AQAA7rJ7InAiOjEsImEiOiJmZWVk…&state=state.passed.in
        
        let queryComponents = url.query!.componentsSeparatedByString("&")
        
        let pairs = queryComponents.map({
            (component: String) -> (field: String, value: String) in
            let pair = component.componentsSeparatedByString("=")
            if pair.count == 2 {
                return (field: pair[0], value: pair[1]) }
            else {
                return (pair[0], "") }})
        
        var codeComponents = pairs.filter({$0.field.lowercaseString == "code"})
        if codeComponents.count == 1 {
            return codeComponents[0].value
        }
        return ""
    }
    
    class func beginGetAccessToken(authenticationCode: String, success: (FeedlyUserAccessTokenInfo) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            
            let url = String(format: Constants.apiURL + "/v3/auth/token")
            
            /*
            POST https://sandbox.feedly.com/v3/auth/token
            
            {
            "client_secret": "YDRYI5E8OP2JKXYSDW79",
            "grant_type"   : "authorization_code",
            "redirect_uri" : "http://localhost",
            "client_id"    : "sandbox",
            "code"         : "AhFI-Cd7ImkiOiI1MjhiZWI1OC1mZTFhLTRjYzAtYmQ4MS1lMjkyMWJlNmUyNTUiLCJ1IjoiM...",
            "state"        : ""
            }
            
            */
            let parameters = [
                FeedlyAuthParameters.code         : authenticationCode,
                FeedlyAuthParameters.clientId     : Constants.clientId,
                FeedlyAuthParameters.clientSecret : Constants.clientSecret,
                FeedlyAuthParameters.redirectUri  : Constants.redirectUrl,
                FeedlyAuthParameters.state        : "",
                FeedlyAuthParameters.grantType    : "authorization_code"
            ]
            
            let manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer() as AFHTTPRequestSerializer
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            let operation = manager.POST(url, parameters: parameters,
                success:  {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    
                    if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                        let userToken = FeedlyUserAccessTokenInfo(json: jsonResult)
                        success(userToken)
                        
                    } else {
                        
                        let error = NSError(domain: FeedlyClientError.domain, code: 1000,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect access token that could not be parsed.", NSLocalizedFailureReasonErrorKey: "Access token response was not in json format or the json format has changed."])
                        failure(error)
                    }
                },
                failure: {
                    (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    failure(error)
            })
            return operation
    }
    
    class func beginGetRefreshToken(refreshToken: String, success: (FeedlyRefreshAccessToken) -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            
            let url = String(format: Constants.apiURL + "/v3/auth/token")
            
            let parameters = [
                FeedlyAuthParameters.refreshToken : refreshToken,
                FeedlyAuthParameters.clientId     : Constants.clientId,
                FeedlyAuthParameters.clientSecret : Constants.clientSecret,
                FeedlyAuthParameters.grantType    : "refresh_token"
            ]
            
            let manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer() as AFHTTPRequestSerializer
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            let operation = manager.POST(url, parameters: parameters,
                success: {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    
                    if let jsonResult = responseObject as? Dictionary<String, String> {
                        _ = FeedlyRefreshAccessToken(json: jsonResult)
                    } else {
                        
                        let error = NSError(domain: FeedlyClientError.domain, code: 1001,
                            userInfo: [NSLocalizedDescriptionKey: "Received an incorrect refresh token response that could not be parsed.", NSLocalizedFailureReasonErrorKey: "Refresh token response was not in json format or the json format has changed."])
                        failure(error)
                    }
                },
                failure: {
                    (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    failure(error)
            })
            
            return operation
    }
    
    class func beginRevokeRefreshToken(refreshToken: String, success: () -> Void, failure: (NSError) -> Void)
        -> AFHTTPRequestOperation {
            
            let url = String(format: Constants.apiURL + "/v3/auth/token")
            
            let parameters = [
                FeedlyAuthParameters.refreshToken : refreshToken,
                FeedlyAuthParameters.clientId     : Constants.clientId,
                FeedlyAuthParameters.clientSecret : Constants.clientSecret,
                FeedlyAuthParameters.grantType    : "revoke_token"
            ]
            
            let manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer() as AFHTTPRequestSerializer
            manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
            
            let operation = manager.POST(url, parameters: parameters,
                success: {
                    (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void  in
                    success()
                },
                failure: {
                    (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    failure(error)
            })
            
            return operation
    }
}

