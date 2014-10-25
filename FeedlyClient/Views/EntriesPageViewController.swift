//
//  EntriesPageViewController.swift
//  FeedlyClient
//
//  Created by Florin Munteanu on 25/10/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

import UIKit

class EntriesPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?
    var currentIndex: Int = 0
    
    var pageTitles = ["God vs Man", "Cool Breeze", "Fire Sky"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.dataSource = self
        
        let startingViewController: EntryPageContentViewController = self.viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as EntryPageContentViewController).pageIndex
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--

        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as EntryPageContentViewController).pageIndex
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> EntryPageContentViewController? {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("EntryPageContentViewController") as EntryPageContentViewController
        
        pageContentViewController.titleText = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        self.currentIndex = index
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
