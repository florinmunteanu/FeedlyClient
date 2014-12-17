
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private var webView: WKWebView?
    
    var entry: Entry? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.entry != nil {
            var keychainData = KeychainService.loadData()
            
            if let token = keychainData?.accessToken {
                
                FeedlyEntriesRequests.beginGetEntry(self.entry!.id, accessToken: token,
                    success: {
                        (feedlyEntry: FeedlyEntry) -> Void in
                        self.webView!.loadRequest(NSURLRequest(URL: NSURL(string: feedlyEntry.origin.htmlUrl)!))
                    }, failure: {
                        (error: NSError) -> Void in
                        
                })
                
                //self.webView!.loadHTMLString(self.entry!.content.content, baseURL: nil)
                
            }
        }
    }
    
    override func loadView() {
        self.webView = WKWebView()
        self.view = self.webView!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
