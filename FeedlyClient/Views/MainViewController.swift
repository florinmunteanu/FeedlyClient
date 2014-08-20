//
//  MainViewController.swift
//  FeedlyClient
//
//  Created by Florin Munteanu on 22/07/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    //    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    //}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender : AnyObject) {
        //self.webView.delegate
        /*
        var auth = FeedlyAuthentication()
        var succes = { (operation: AFHTTPRequestOperation!, object: AnyObject!) -> Void in
            
        }
        var failure = { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
        }
        var request = NSURLRequest(URL: NSURL(string: "http://sandbox.feedly.com/v3/auth/auth?client_id=sandbox&redirect_uri=https%3A%2F%2Flocalhost&scope=https%3A%2F%2Fcloud.feedly.com%2Fsubscriptions&response_type=code"))
        self.webView.loadRequest(request);
        */
        //var fa = FeedlyAuthentication()
        //var url = fa.authenticationUrl()
        var loginController = LoginViewController()
    
        self.presentViewController(loginController, animated: false, completion: {()->Void in
            // save in keychain
            
            })
        //LoginViewController().presentViewController(self, animated: false, completion: nil)
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
