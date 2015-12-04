
import Foundation
import CoreData

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedlyUserLogin {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        
    }
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    @IBAction func doneClicked(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return self.getUserCell(tableView, forIndexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath)
            
            return cell
        }
    }
    /*
    - (void)delayContentTouches:(UITableViewCell *)cell
    {
    //http://stackoverflow.com/questions/19256996/uibutton-not-showing-highlight-on-tap-in-ios7
    
    // https://developer.apple.com/library/ios/documentation/uikit/reference/uiscrollview_class/Reference/UIScrollView.html#//apple_ref/occ/instp/UIScrollView/delaysContentTouches
    // delaysContentTouches
    // A Boolean value that determines whether the scroll view delays the handling of touch-down gestures.
    for (id obj in cell.subviews)
    {
    if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
    {
    UIScrollView *scroll = (UIScrollView *) obj;
    scroll.delaysContentTouches = NO;
    break;
    }
    }
    }*/
    
    //func delayContentTouches(cell: UITableViewCell) {
    //    for view in cell.subviews {
    //class_getName(view)
    //NSStringFromClass(view.class)
    //let myObject: view.Type = view.self
    
    //    }
    //}
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "User"
        }
        return ""
    }
    /*
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    if section == 0 {
    return "v1.0"
    }
    return ""
    }*/
    
    // MARK: Cells
    
    func getUserCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var keychainData: KeychainData?
        do {
            keychainData = try KeychainService.loadData()
        } catch {
        }
        
        var cell: UITableViewCell
        if let _ = keychainData?.accessToken {
            cell = tableView.dequeueReusableCellWithIdentifier("LogoutCell", forIndexPath: indexPath) //as LogoutTableViewCell
            cell.textLabel!.text = keychainData!.userName
            
            self.setLogoutCell(cell, data: keychainData!)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("LoginCell", forIndexPath: indexPath) //as LoginTableViewCell
            self.setLoginCell(cell)
        }
        
        return cell
    }
    
    func refreshUserCell() {
        self.settingsTableView.beginUpdates()
        self.settingsTableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        self.settingsTableView.endUpdates()
    }
    
    func setLoginCell(cell: UITableViewCell) {
        
        let loginButton = UIButton()
        loginButton.frame = cell.bounds
        loginButton.backgroundColor = UIColor.blueColor()
        
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.setTitle("Login", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.accessoryView = nil
        
        cell.contentView.addSubview(loginButton)
    }
    
    func setLogoutCell(cell: UITableViewCell, data: KeychainData) {
        cell.textLabel!.text = data.userName
        let logoutButton = UIButton()
        logoutButton.frame = CGRectMake(0.0, 0.0, 60.0, 25.0)
        logoutButton.backgroundColor = UIColor.redColor()
        
        logoutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logoutButton.setTitle("Logout", forState: UIControlState.Normal)
        cell.accessoryView = logoutButton
        
        logoutButton.addTarget(self, action: "logout:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: Login / Logout
    func login(loginButton: UIButton) {
        let loginController = LoginViewController()
        loginController.delegate = self
        self.presentViewController(loginController, animated: false,
            completion: {() -> Void in
                self.refreshUserCell()
        })
    }
    
    func logout(logoutButton: UIButton) {
        var keychainData: KeychainData?
        do {
            keychainData = try KeychainService.loadData()
        } catch {
        }
        
        if let refreshToken = keychainData?.refreshToken {
            FeedlyAuthenticationRequests.beginRevokeRefreshToken(refreshToken,
                success: {
                    () -> Void in
                    do {
                        try KeychainService.clearData()
                    } catch {
                    }
                    
                    self.refreshUserCell()
                },
                failure: {
                    (error: NSError) -> Void in
                    self.displayLogoutError(error)
            })
        }
    }
    
    private func displayLogoutError(error: NSError) {
        let alert = UIAlertController(title: "Error", message: "There was an error during logout process.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // FeedlyUseLogin
    // https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/ManagingDataFlowBetweenViewControllers/ManagingDataFlowBetweenViewControllers.html#//apple_ref/doc/uid/TP40007457-CH8-SW9
    
    func userLoggedIn(userAccessTokenInfo: FeedlyUserAccessTokenInfo, userProfile: FeedlyUserProfile) {
        
        let data = KeychainData()
        data.accessToken = userAccessTokenInfo.accessToken
        data.refreshToken = userAccessTokenInfo.refreshToken
        data.userName = userProfile.fullName
        
        do {
            try KeychainService.saveData(data)
        } catch {
            
        }
        
        self.refreshUserCell()
    }
}