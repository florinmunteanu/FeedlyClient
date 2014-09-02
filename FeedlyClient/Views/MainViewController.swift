
import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    //    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    // Custom initialization
    //}
    
    //@IBOutlet weak var subscriptionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.subscriptionsTableView.delegate = self
        //self.beginLoadSubscriptions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender : AnyObject) {
        var loginController = LoginViewController()
        //loginController.delegate = self
        self.presentViewController(loginController, animated: false, completion: nil)
    }
    
    func beginLoadSubscriptions() {
        var accessToken = KeychainService.loadAccessToken()
        
        //REDO : if we have access token and there's nothing saved in Core Data ?
        if let token = accessToken {
            /*
            var subscriptionsOperation = FeedlySubscriptions().beginGetSubscriptions(token,
                success: {
                    (subscriptions: [Subscription]) -> Void in
                    
                },
                failure: {
                    (error: NSError) -> Void in
                    // display tsmessage
            })
            */
            
            //FeedlyStreams().beginGetStream(
            //FeedlyEntries().beginGetEntrie(streamId)
        }
    }
    
    func startLoadingAnimation() {
        
    }
    
    func stopLoadingAnimation() {
        
    }
    
    // LoginProtocol
    // https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/ManagingDataFlowBetweenViewControllers/ManagingDataFlowBetweenViewControllers.html#//apple_ref/doc/uid/TP40007457-CH8-SW9
    
    //func userLoggedIn(userAccessTokenInfo: UserAccessTokenInfo) {
    //    KeychainService.saveAccessToken(userAccessTokenInfo.accessToken)
    //}
    
    // UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("SubscriptionCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = "a"
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView!, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath!) {
        
    }
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
