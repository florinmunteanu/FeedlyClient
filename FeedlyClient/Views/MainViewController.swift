//
//  MainViewController.swift
//  FeedlyClient
//
//  Created by Florin Munteanu on 22/07/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender : AnyObject) {
        var auth = FeedlyAuthentication()
        var succes = { (operation: AFHTTPRequestOperation!, object: AnyObject!) -> Void in
            
        }
        var failure = { (operation: AFHTTPRequestOperation!, object: AnyObject!) -> Void in
        }
        
        
        var parameters = [ "response_type" : "code",
            "client_id"     : Constants.clientId,
            "redirect_uri"  : Constants.redirectUrl.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
            "scope"         : Constants.scope];
        var serializer = AFHTTPRequestSerializer()
        var request = serializer.requestWithMethod("GET", URLString: Constants.apiURL + "/v3/auth/auth", parameters: parameters, error: nil)
        
        //var operation = AFHTTPRequestOperation(request: request)
        //operation.responseSerializer = serializer
        
        var manager = AFHTTPRequestOperationManager();
        manager.GET(Constants.apiURL + "/v3/auth/auth", parameters: parameters, success: succes, failure: failure)

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
