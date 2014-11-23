
import Foundation
import CoreData

class __CategorySubscriptionsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // On refresh: Get Stream by categoryId, then get entries by entries ids returned by stream.
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var categoryId: String? = "6"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        self.refreshControl = refreshControl
        
        self.tableView.rowHeight = 75//UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 75
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        if self.categoryId != nil {
            self.beginLoadStream(categoryId!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Entry" {
            var entryViewController = segue.destinationViewController as EntryViewController
            entryViewController.entry = sender as? Entry
        }
    }
    
    private func beginLoadStream(categoryId: String) {
        var keychainData = KeychainService.loadData()
        
        if let token = keychainData?.accessToken {
            if let categoryId = self.categoryId {
                
                var options = FeedlyStreamSearchOptions()
                options.accessToken = token
                
                FeedlyStreamsRequests.beginGetStream(categoryId, options: options,
                    success: {
                        (stream: FeedlyStream) -> Void in
                        if stream.entries.count > 0 {
                            self.beginLoadEntries(stream.entries, accessToken: token)
                        } else {
                            // No entries downloaded
                            self.endRefreshing()
                        }
                    },
                    failure: {
                        (error: NSError) -> Void in
                        self.endRefreshing()
                        Alerts.displayError("An error occurred while refreshing the entries. Please try again.", onUIViewController: self)
                })
            }
        }
    }
    
    private func beginLoadEntries(entries: [String], accessToken: String) {
        FeedlyEntriesRequests.beginGetEntries(entries, accessToken: accessToken,
            success: {
                (entriesDictionary: Dictionary<String, FeedlyEntry>) -> Void in
                
                var error: NSError? = nil
                self.updateEntries(entriesDictionary, error: &error)
                
                self.endRefreshing()
                self.tableView.reloadData()
                if error != nil {
                    Alerts.displayError("An error occurred while refreshing the entries. Please try again.", onUIViewController: self)
                }
                
            },
            failure: {
                (error: NSError) -> Void in
                self.endRefreshing()
                Alerts.displayError("An error occurred while refreshing the entries. Please try again.", onUIViewController: self)
        })
    }
    
    func updateEntries(entries: Dictionary<String, FeedlyEntry>, error: NSErrorPointer) {
        if self.managedObjectContext != nil {
            
            for entry in entries {
                Entry.addOrUpdate(entry.1, inManagedObjectContext: self.managedObjectContext!, error: error)
                // Stop processing on first error
                if error != nil && error.memory != nil {
                    return
                }
                if let visual = entry.1.visual {
                    ImagesDownloader.sharedInstance.queueImage(visual.url, entryId: entry.1.id,
                        success: {
                            (entryId, thumbnailImage) -> Void in
                            Entry.updateThumbnail(entryId, thumbnail: thumbnailImage, inManagedObjectContext: self.managedObjectContext!, error: error)
                    })
                }
            }
        }
    }
    
    private func endRefreshing() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshed")
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Entry", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "ANY categories.id==%@", self.categoryId!)
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "published", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
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
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? EntryTableViewCell {
                self.configureCell(cell, atIndexPath: indexPath)
            }
            //self.configureCell(self.tableView(self.tableView, cellForRowAtIndexPath: indexPath), atIndexPath: indexPath)
            //self.configureCell(tableView.cellForRowAtIndexPath(indexPath)! as EntryTableViewCell, atIndexPath: indexPath)
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
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EntryCell", forIndexPath: indexPath) as EntryTableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        var entry: AnyObject! = self.fetchedResultsController.objectAtIndexPath(indexPath) as Entry
        self.performSegueWithIdentifier("Entry", sender: entry)
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: Configure cell
    
    func configureCell(cell: EntryTableViewCell, atIndexPath indexPath: NSIndexPath) {
        var entry = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Entry
        
        cell.titleLabel.text = entry?.title
        cell.summaryLabel.text = entry?.textSummary
        cell.authorLabel.text = entry?.author
        if let thumbnail = entry?.thumbnail {
            cell.thumbnailImageView.image = UIImage(data: thumbnail)
            //cell.imageView.image = UIImage(data: thumbnail)
        } else {
            cell.thumbnailImageView.image = nil
            //cell.imageView.image = nil
        }
    }
}