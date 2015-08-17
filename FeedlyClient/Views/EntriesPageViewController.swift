
import UIKit

class EntriesPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private var pageViewController: UIPageViewController?
    private var currentIndex: Int = 0
    
    var selectedEntry: Entry? = nil
    var entries: [Entry]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.dataSource = self
        
        let startingViewController: EntryPageContentViewController = self.viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: false, completion: nil)
        self.pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! EntryPageContentViewController).index
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--

        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! EntryPageContentViewController).index
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == self.entries?.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> EntryPageContentViewController? {
        if self.entries == nil || index >= self.entries!.count {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("EntryPageContentViewController") as! EntryPageContentViewController
        
        pageContentViewController.entry = self.entries?[index]
        pageContentViewController.index = index
        self.currentIndex = index
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.entries?.count ?? 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
