
import Foundation

class FeedlyAuthenticationURLProtocol : NSURLProtocol, NSURLConnectionDataDelegate {
    
    var connection: NSURLConnection? = nil
    
    override class func canInitWithRequest(request: NSURLRequest!) -> Bool {
        NSLog(request.description)
        if request != nil && request.URL != nil && request.URL.path != nil && request.URL.path.rangeOfString("Callback") {
            NSLog(request.description)
            return true
        }
        return false
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest!) -> NSURLRequest! {
        return request
    }
    
    override class func requestIsCacheEquivalent(a: NSURLRequest!, toRequest b: NSURLRequest!) -> Bool {
        return super.requestIsCacheEquivalent(a, toRequest: b)
    }
    
    override func startLoading() {
        self.connection = NSURLConnection(request: self.request, delegate:self)
    }
    
    override func stopLoading()  {
        self.connection!.cancel()
        self.connection = nil
    }
    
    // NSURLConnectionDelegate
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        
    }
    
    // NSURLConnectionDataDelegate
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        self.client.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.client.URLProtocol(self, didLoadData: data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        self.client.URLProtocolDidFinishLoading(self)
    }
}