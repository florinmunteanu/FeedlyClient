
import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    init() {
        super.init(nibName: "LoginViewController", bundle: NSBundle.mainBundle())
    }
    
    init(coder aDecoder: NSCoder!) {
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
                    self.activityIndicator.stopAnimating()
                },
                failure: {(error:NSError) -> Void in
                    self.activityIndicator.stopAnimating()
                })
            
            return false // Do not further process this request
        }
        else {
            return true
        }
    }
    
    func isAuthorizationCodeRequest(request: NSURLRequest!) -> Bool {
        return request != nil && request.URL != nil && request.URL.path != nil && request.URL.description.rangeOfString("code=")
    }
    
    func startActivityIndicator() {
        
        //self.activityIndicator!.startAnimating()
        //self.alertView!.show()
    }
    
    func stopActivityIndicator() {
        //self.activityIndicator!.stopAnimating()
        //self.alertView!.dismissWithClickedButtonIndex(0, animated: true)
    }
}
