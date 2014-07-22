
import Foundation

class FeedlyAuthentication {
    func authenticationUrl(success: ((AFHTTPRequestOperation!, AnyObject!) -> Void)?,
        failure: ((AFHTTPRequestOperation!, NSError!) -> Void)?) {
        //var manager = AFHTTPRequestOperationManager()
        //var authUrl = Constants.apiURL + "/v3/auth/auth?"
        //authUrl += "response_type=code"
        //authUrl += "&client_id=" + Constants.clientId
        //authUrl += "&redirect_uri=" + Constants.redirectUrl.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        //authUrl += "&scope=" + Constants.scope
        //authUrl = authUrl.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
     
        //var url = NSURL(string: authUrl)
        //var request = NSURLRequest(URL: url)
        
        var parameters = [ "response_type" : "code",
                           "client_id"     : Constants.clientId,
                           "redirect_uri"  : Constants.redirectUrl.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
                           "scope"         : Constants.scope];
        var serializer = AFHTTPRequestSerializer()
        var request = serializer.requestWithMethod("GET", URLString: Constants.apiURL + "/v3/auth/auth", parameters: parameters, error: nil)
        
        //var operation = AFHTTPRequestOperation(request: request)
        //operation.responseSerializer = serializer
        
        var manager = AFHTTPRequestOperationManager();
        manager.GET(Constants.apiURL + "/v3/auth/auth", parameters: parameters, success: success, failure: failure)
        
    }
}

