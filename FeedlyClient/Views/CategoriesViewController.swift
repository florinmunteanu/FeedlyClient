
import Foundation
import CoreData

class CategoriesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        self.refreshControl = refreshControl
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        self.loadSubscriptions()
        
        refreshControl.endRefreshing()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshed")
    }
    
    func loadSubscriptions() {
        var accessToken = KeychainService.loadAccessToken()
        
        if let token = accessToken {
            var subscriptionsOperation = FeedlySubscriptionsRequests.beginGetSubscriptions(token,
                success: {
                    (subscriptions: [FeedlySubscription]) -> Void in
                    self.insertSubscriptions(subscriptions, error: nil)
                    self.tableView.reloadData()
                },
                failure: {
                    (error: NSError) -> Void in
                    
            })
        }
    }
    
    func insertSubscriptions(subscriptions: [FeedlySubscription], error: NSErrorPointer) {
        if self.managedObjectContext != nil {
            for subscription in subscriptions {
                Subscription.addOrUpdate(subscription, inManagedObjectContext: self.managedObjectContext!, error: nil)
            }
        }
    }
    
    // MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
            }
            
            let fetchRequest = NSFetchRequest()
            let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: self.managedObjectContext!)
            fetchRequest.entity = entity
            
            fetchRequest.fetchBatchSize = 20
            
            let sortDescriptor = NSSortDescriptor(key: "label", ascending: true)
            let sortDescriptors = [sortDescriptor]
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // Edit the section name key path and cache name if appropriate.
            // nil for section name key path means "no sections".
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "CategoriesCache")
            aFetchedResultsController.delegate = self
            _fetchedResultsController = aFetchedResultsController
            
            var error: NSError? = nil
            if _fetchedResultsController!.performFetch(&error) == false {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                //abort()
            }
            
            return _fetchedResultsController!
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SubscriptionCell", forIndexPath: indexPath) as UITableViewCell
        //cell.textLabel?.text = "a"
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }
}