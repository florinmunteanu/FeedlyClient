
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
        
        self.webView!.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit {
        self.webView!.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func loadEntry(entryId: String) {
        
        ProgressHud.beginProgress()
        
        let keychainData = KeychainService.loadDataSafe()
        
        if let token = keychainData.accessToken {
            FeedlyEntriesRequests.beginGetEntry(entryId,
                accessToken: token,
                progress: nil,
                success: {
                    (feedlyEntry: FeedlyEntry) -> Void in
                    ProgressHud.endProgress()
                    self.presentEntry(feedlyEntry)
                },
                failure: {
                    (error: NSError) -> Void in
                    ProgressHud.endProgress()
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
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let path = keyPath {
            if path == "estimatedProgress" {
                observeEstimatedProgress()
            }
        }
    }
    
    private func observeEstimatedProgress() {
        let currentProgress = Float(self.webView!.estimatedProgress)
        
        if currentProgress == 1.0 {
            ProgressHud.endProgress()
        } else {
            ProgressHud.reportProgress(currentProgress)
        }
    }
}
