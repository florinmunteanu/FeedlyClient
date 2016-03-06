
import Foundation
import CoreData

class CategoriesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        self.refreshControl = refreshControl
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        self.refresh()
    }
    
    private func refresh() {
        
        let keychainData = KeychainService.loadDataSafe()
        
        if let accessToken = keychainData.accessToken,
            let managedObjectContext = self.managedObjectContext {
                
                let refreshLogic: SubscriptionsRefreshLogic = SubscriptionsRefreshLogic(accessToken: accessToken, managedObjectContext: managedObjectContext)
                refreshLogic.success = {
                    self.endRefreshing();
                }
                refreshLogic.failure = {
                    (error: NSError) -> Void in
                    self.endRefreshing()
                    Alerts.displayError("An error occurred while refreshing the subscriptions", onUIViewController: self)
                }
                
                refreshLogic.run()
        }
    }
    
    private func endRefreshing() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshed")
        self.refreshControl?.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Settings" {
            
            let settingsViewController = segue.destinationViewController as! SettingsViewController
            settingsViewController.managedObjectContext = self.managedObjectContext
            
        } else if segue.identifier == "Subscriptions" {
            
            let cell = sender as! UITableViewCell
            let cellIndexPath = self.tableView.indexPathForCell(cell)
            
            if cellIndexPath != nil {
                let category = self.fetchedResultsController.objectAtIndexPath(cellIndexPath!) as! Category
                
                let controller = segue.destinationViewController as! UINavigationController
                
                let childController = controller.viewControllers[0] as! CategoryEntriesTableViewController
                childController.managedObjectContext = self.managedObjectContext
                childController.categoryId = category.id
                childController.categoryName = category.label
                
                self.setupNavigationItem(childController)
            }
        }
    }
    
    private func setupNavigationItem(controller: UIViewController) {
        // http://nshipster.com/uisplitviewcontroller/
        //
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
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
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "CategoriesCache")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        //var error: NSError? = nil
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            
        }
        //if  == false {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //println("Unresolved error \(error), \(error.userInfo)")
        //abort()
        //}
        
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
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
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
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let category = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Category
        cell.textLabel!.text = category?.label
    }
}