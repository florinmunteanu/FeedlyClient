
import Foundation

class FeedlyAuthentication {
    /*
    func authenticationUrl(success: ((AFHTTPRequestOperation!, AnyObject!) -> Void)?,
    failure: ((AFHTTPRequestOperation!, NSError!) -> Void)?) {
    
    var parameters = [ "response_type" : "code",
    "client_id"     : Constants.clientId,
    "redirect_uri"  : Constants.redirectUrl.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
    "scope"         : Constants.scope];
    var serializer = AFHTTPRequestSerializer()
    var request = serializer.requestWithMethod("GET", URLString: Constants.apiURL + "/v3/auth/auth", parameters: parameters, error: nil)
    
    //var operation = AFHTTPRequestOperation(request: request)
    //operation.responseSerializer = serializer
    // http://sandbox.feedly.com/v3/auth/auth?client_id=sandbox&redirect_uri=https%3A%2F%2Flocalhost&scope=https%3A%2F%2Fcloud.feedly.com%2Fsubscriptions&response_type=code
    var manager = AFHTTPRequestOperationManager();
    manager.GET(Constants.apiURL + "/v3/auth/auth", parameters: parameters, success: success, failure: failure)
    
    }*/
    
    func authenticationUrl() -> String {
        var queryParameters = [
            Constants.responseTypeParameter  : "code",
            Constants.clientIdParameter      : Constants.clientId,
            Constants.redirectUriParameter   : Constants.redirectUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()),
            Constants.scopeParameter         : Constants.scope.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())];
        
        var url = String(Constants.apiURL + "/v3/auth/auth?")
        for (index, entry) in enumerate(queryParameters) {
            url = url.stringByAppendingFormat(index == queryParameters.count - 1 ? "%@=%@" : "%@=%@&", entry.0, entry.1)
        }
        return url
    }
    
    func getAuthenticationCode(url: NSURL) -> String {
        // Should receive an url in the form of:
        // https://your.redirect.uri/feedlyCallback?code=AQAA7rJ7InAiOjEsImEiOiJmZWVk…&state=state.passed.in
        
        var queryComponents = url.query.componentsSeparatedByString("&")
        
        var pairs = queryComponents.map({
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
    
    func beginGetAccessToken(authenticationCode: String, success: (UserAccessToken) -> Void, failure: (NSError) -> Void) {
        var url = String(Constants.apiURL + "/v3/auth/token")
        
        var parameters = [
            Constants.codeParameter         : authenticationCode,
            Constants.clientIdParameter     : Constants.clientId,
            Constants.clientSecretParameter : Constants.clientSecret,
            Constants.redirectUriParameter  : Constants.redirectUrl,
            Constants.stateParameter        : "",
            Constants.grantTypeParameter    : "authorization_code"
        ]
        var manager = AFHTTPRequestOperationManager()
        
        manager.POST(url, parameters: parameters,
            success:  {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void  in
            
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                let a = 10
            })
    }
}

