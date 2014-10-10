
import Foundation
class SubscriptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var appDelegate = [[UIApplication sharedApplication] delegate]
        
        //let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        //delegate?.saveContext()
        self.beginLoadSubscriptions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var subscriptionsTableView: UITableView!
    
    @IBAction func buttonClicked(sender : AnyObject) {
        //var loginController = LoginViewController()
        //loginController.delegate = self
        //self.presentViewController(loginController, animated: false, completion: nil)
    }
    
    func beginLoadSubscriptions() {
        var keychainData = KeychainService.loadData()
        
        //REDO : if we have access token and there's nothing saved in Core Data ?
        if let token = keychainData?.accessToken {
            var subscriptionsOperation = FeedlySubscriptionsRequests.beginGetSubscriptions(token,
                success: {
                    (subscriptions: [FeedlySubscription]) -> Void in
                    
                    self.subscriptionsTableView.reloadData()
                },
                failure: {
                    (error: NSError) -> Void in
                    // display tsmessage
            })
            FeedlyCategoriesRequests.beginGetCategories(token, success: {
                (categories: [FeedlyCategory]) -> Void in
                
                
                }, failure: { (error: NSError) -> Void in
            })
            //FeedlyStreams().beginGetStream(
            //FeedlyEntries().beginGetEntrie(streamId)
        }
    }
    
    // FeedlyUseLogin
    // https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/ManagingDataFlowBetweenViewControllers/ManagingDataFlowBetweenViewControllers.html#//apple_ref/doc/uid/TP40007457-CH8-SW9
    /*
    func userLoggedIn(userAccessTokenInfo: FeedlyUserAccessTokenInfo) {
        var data = KeychainData()
        data.accessToken = userAccessTokenInfo.accessToken
        data.userName = userAccessTokenInfo.userId
        
        KeychainService.saveData(data)
    }
*/
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SubscriptionCell", forIndexPath: indexPath) as UITableViewCell
        //cell.textLabel?.text = "a"
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }
}