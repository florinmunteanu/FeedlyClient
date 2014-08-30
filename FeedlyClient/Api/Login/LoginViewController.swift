
import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    override init() {
        super.init(nibName: "LoginViewController", bundle: NSBundle.mainBundle())
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        var url = FeedlyAuthentication().authenticationUrl()
        var request = NSURLRequest(URL: NSURL(string: url))
        self.webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        if self.isAuthorizationCodeRequest(request) {
            self.activityIndicator.startAnimating()
            
            var auth = FeedlyAuthentication()
            var code = auth.getAuthenticationCode(request.URL)
            
            auth.beginGetAccessToken(code,
                success: {(userToken: UserAccessToken) -> Void in
                    // Set the current feedly user token
                    //CurrentFeedlyUser.token = userToken
                    /*FeedlyCategories().beginGetCategories(userToken.accessToken,
                    success: {([Category]) -> Void in
                    
                    },
                    failure: {(NSError) -> Void in
                    
                    })*/
                    //FeedlySubscriptions().beginGetSubscriptions(userToken.accessToken,
                    //    success: {([Subscription]) -> Void in
                    //
                    //    }, failure: {(NSError) -> Void in
                    //})
                    //var options = StreamSearchOptions()
                    //options.accessToken = userToken.accessToken
                    //FeedlyStreams().beginGetStream(
                    //    "feed/https://developer.apple.com/swift/blog/news.rss",
                    //    options: options,
                    //    success: {
                    //       (stream: Stream) -> Void in
                    //
                    //    },
                    //    failure: { (error: NSError) -> Void in
                    //})
                    /*entries = 12 values {
                        [0] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_14818d7b4e5:ca31:23535a44"
                        [1] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147f0bdae0d:1480d:1be42e7e"
                        [2] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147db9610ac:5a88:e0e8dc38"
                        [3] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147b75f294a:6a2c9:bda086f"
                        [4] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147a8a73a35:36f1a:bda086f"
                        [5] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1479397e732:ba:bda086f"
                        [6] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1477e63e58e:13f8:d9c45486"
                        [7] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1476575ba31:46d22:cdf4c12c"
                        [8] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1474bfa2ab5:210f:cdf4c12c"
                        [9] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1473af76e80:45a8e:899a63a0"
                        [10] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147265dfe80:45a8d:899a63a0"
                        [11] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147265dfe80:45a8c:899a63a0"*/
                    FeedlyEntries().beginGetEntry("vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_14818d7b4e5:ca31:23535a44",
                        accessToken: userToken.accessToken,
                        success: {
                        (entry: Entry) -> Void in
                        //self.webView.loadHTMLString(<#string: String!#>, baseURL: <#NSURL!#>)
                        }, failure: { (error:NSError) -> Void in
                        
                    })
                    self.activityIndicator.stopAnimating()
                },
                failure: {(error:NSError) -> Void in
                    self.activityIndicator.stopAnimating()
                    self.displayAlert(error)
            })
            
            return false // Do not further process this request
        }
        else {
            return true
        }
    }
    
    func displayAlert(error: NSError) {
        var alert = UIAlertController(title: "Error", message: "There was an error during authorization process.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func isAuthorizationCodeRequest(request: NSURLRequest!) -> Bool {
        return request != nil &&
            request.URL != nil &&
            request.URL.path != nil &&
            request.URL.description.rangeOfString("code=") != nil &&
            request.URL.description.rangeOfString(Constants.redirectUrl) != nil
    }
}
