
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
        
        self.beginLoadSubscriptions()
    }
    
    private func beginLoadSubscriptions() {
        var keychainData = KeychainService.loadData()
        
        if let token = keychainData?.accessToken {
            var subscriptionsOperation = FeedlySubscriptionsRequests.beginGetSubscriptions(token,
                success: {
                    (subscriptions: [FeedlySubscription]) -> Void in
                    var error: NSError? = nil
                    self.updateSubscriptions(subscriptions, error: &error)
                    
                    self.endRefreshing()
                    //self.tableView.reloadData()
                    if error != nil {
                        Alerts.displayError("An error occurred while refreshing the subscriptions. Please try again.", onUIViewController: self)
                    }
                },
                failure: {
                    (error: NSError) -> Void in
                    self.endRefreshing()
                    Alerts.displayError("An error occurred while refreshing the subscriptions. Please try again.", onUIViewController: self)
            })
        } else {
            self.endRefreshing()
            // display the login view controller
        }
    }
    
    private func endRefreshing() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshed")
        self.refreshControl?.endRefreshing()
    }
    
    func updateSubscriptions(subscriptions: [FeedlySubscription], error: NSErrorPointer) {
        if self.managedObjectContext != nil {
            
            for subscription in subscriptions {
                Subscription.addOrUpdate(subscription, inManagedObjectContext: self.managedObjectContext!, error: error)
                // Stop processing on first error
                if error != nil && error.memory != nil {
                    return
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Settings" {
            
            var settingsViewController = segue.destinationViewController as SettingsViewController
            settingsViewController.managedObjectContext = self.managedObjectContext
            
        } else if segue.identifier == "Subscriptions" {
            
            var cell = sender as UITableViewCell
            var cellIndexPath = self.tableView.indexPathForCell(cell)
            
            if cellIndexPath != nil {
                var category = self.fetchedResultsController.objectAtIndexPath(cellIndexPath!) as Category
                
                var controller = segue.destinationViewController as UINavigationController
                var childController = controller.viewControllers[0] as CategoryEntriesCollectionViewController
                childController.managedObjectContext = self.managedObjectContext
                childController.categoryId = category.id
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
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath)!, atIndexPath: indexPath)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let category = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Category
        cell.textLabel.text = category?.label
    }
}