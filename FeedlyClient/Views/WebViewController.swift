
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private var webView: WKWebView?
    
    var entry: Entry? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entryId = entry?.id {
            loadEntry(entryId)
        }
    }
    
    override func loadView() {
        self.webView = WKWebView()
        self.view = self.webView!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func loadEntry(entryId: String) {
        let keychainData = KeychainService.loadDataSafe()
        
        if let token = keychainData.accessToken {
            FeedlyEntriesRequests.beginGetEntry(entryId,
                accessToken: token,
                success: {
                    (feedlyEntry: FeedlyEntry) -> Void in
                    self.presentEntry(feedlyEntry)
                },
                failure: {
                    (error: NSError) -> Void in
                    Alerts.displayError("An error occurred loading the entry. Please try again.", onUIViewController: self)
            })
        }
    }
    
    private func presentEntry(feedlyEntry: FeedlyEntry) {
        if isContentEmpty(feedlyEntry) {
            self.webView!.loadRequest(NSURLRequest(URL: NSURL(string: feedlyEntry.origin.htmlUrl)!))
        } else{
            self.webView!.loadHTMLString(feedlyEntry.content!.content, baseURL: nil)
        }
    }
    
    
    private func isContentEmpty(feedlyEntry: FeedlyEntry) -> Bool {
        if let feedContent = feedlyEntry.content {
            return feedContent.content.isEmpty
        }
        return true
    }
}
