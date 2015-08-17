
import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "LoginViewController", bundle: NSBundle.mainBundle())
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        var url = FeedlyAuthenticationRequests.authenticationUrl()
        var request = NSURLRequest(URL: NSURL(string: url)!)
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
    
    var delegate: FeedlyUserLogin?
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if self.isAuthorizationCodeRequest(request) {
            
            self.activityIndicator.startAnimating()
            var code = FeedlyAuthenticationRequests.getAuthenticationCode(request.URL!)
            
            var accessTokenOperation = FeedlyAuthenticationRequests.beginGetAccessToken(code,
                success: {
                    (userToken: FeedlyUserAccessTokenInfo) -> Void in
                    self.beginGetUserProfile(userToken)
                },
                failure: {
                    (error:NSError) -> Void in
                    self.activityIndicator.stopAnimating()
                    self.displayAlert(error)
            })
            return false // Do not further process this request
        }
        else {
            return true
        }
    }
    
    private func beginGetUserProfile(tokenInfo: FeedlyUserAccessTokenInfo) {
        FeedlyUserProfileRequests.beginGetUserProfile(tokenInfo.accessToken,
            success: {
                (userProfile: FeedlyUserProfile) -> Void in
                
                if self.delegate != nil {
                    self.delegate!.userLoggedIn(tokenInfo, userProfile: userProfile)
                    self.activityIndicator.stopAnimating()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            },
            failure: {
                (error: NSError) -> Void in
                self.activityIndicator.stopAnimating()
                self.displayAlert(error)
            }
        )
    }
    
    private func displayAlert(error: NSError) {
        var alert = UIAlertController(title: "Error", message: "There was an error during the authorization process.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func isAuthorizationCodeRequest(request: NSURLRequest) -> Bool {
        return request.URL!.path != nil &&
            request.URL!.description.rangeOfString("code=") != nil &&
            request.URL!.description.rangeOfString(Constants.redirectUrl) != nil
    }
}
