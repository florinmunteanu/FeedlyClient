
import Foundation
import CoreData

class CategoryEntriesTableViewController: UITableViewController,  NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var categoryId: String? = "6"
    
    var categoryName: String? {
        didSet {
            self.title = self.categoryName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        self.refreshControl = refreshControl
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 75
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.tableView.tableFooterView = UIView()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        self.refresh()
    }
    
    func refresh() {
        if self.categoryId != nil {
            self.beginLoadStream(categoryId!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Entry" {
            let entryViewController = segue.destinationViewController as! EntryViewController
            
            if let selectedCell = sender as? EntryTableViewCell,
                let indexPath = self.tableView!.indexPathForCell(selectedCell){
                    
                    let currentEntry = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Entry
                    let entries = self.fetchedResultsController.fetchedObjects as! [Entry]
                    
                    entryViewController.selectedEntry = currentEntry
                    entryViewController.entries = entries
                    entryViewController.managedObjectContext = self.managedObjectContext
            }
        }
    }
    
    // On refresh: Get Stream by categoryId, then get entries by entries ids returned by stream.
    
    private func beginLoadStream(categoryId: String) {
        var keychainData: KeychainData?
        
        do {
            keychainData = try KeychainService.loadData()
        } catch {
            Alerts.displayError("An error occurred while refreshing the entries. Please try again.", onUIViewController: self)
            return
        }
        
        if let token = keychainData?.accessToken,
            categoryId = self.categoryId {
                let options = FeedlyStreamSearchOptions()
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
    
    private func beginLoadEntries(entries: [String], accessToken: String) {
        FeedlyEntriesRequests.beginGetEntries(entries, accessToken: accessToken,
            success: {
                (entriesDictionary: Dictionary<String, FeedlyEntry>) -> Void in
                
                var errorOccurred = false
                do {
                    try self.updateEntries(entriesDictionary)
                } catch {
                    errorOccurred = true
                }
                
                self.endRefreshing()
                self.tableView!.reloadData()
                
                if errorOccurred {
                    Alerts.displayError("An error occurred while refreshing the entries. Please try again.", onUIViewController: self)
                }
                
            },
            failure: {
                (error: NSError) -> Void in
                self.endRefreshing()
                Alerts.displayError("An error occurred while refreshing the entries. Please try again.", onUIViewController: self)
        })
    }
    
    func updateEntries(entries: Dictionary<String, FeedlyEntry>) throws {
        if self.managedObjectContext != nil {
            for entry in entries {
                try self.updateEntry(entry)
            }
        }
    }
    
    func updateEntry(entry: (String, FeedlyEntry)) throws {
        try Entry.addOrUpdate(entry.1, inManagedObjectContext: self.managedObjectContext!)
        
        if let visual = entry.1.visual {
            ImagesDownloader.sharedInstance.queueImage(visual.url, entryId: entry.1.id,
                success: {
                    (entryId, thumbnailImage) -> Void in
                    self.tryUpdateThumbnail(thumbnailImage, entryId: entryId, numberOfRetries: 2)
            })
        }
    }
    
    func tryUpdateThumbnail(thumbnailImage: NSData, entryId: String, var numberOfRetries: uint = 2) {
        while numberOfRetries > 0 {
            do {
                try Entry.updateThumbnail(entryId, thumbnail: thumbnailImage, inManagedObjectContext: self.managedObjectContext!)
                numberOfRetries = 0
            } catch {
                numberOfRetries--
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
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            
        }
        
        return _fetchedResultsController!
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView!.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView!.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            self.tableView!.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let insertedIndexPath = newIndexPath {
                self.tableView!.insertRowsAtIndexPaths([insertedIndexPath], withRowAnimation: .Automatic)
            }
            
        case .Delete:
            if let deletedIndexPath = indexPath {
                self.tableView!.deleteRowsAtIndexPaths([deletedIndexPath], withRowAnimation: .Automatic)
            }
            
        case .Update:
            if let updatedIndexPath = indexPath,
                cell = tableView.cellForRowAtIndexPath(updatedIndexPath) as? EntryTableViewCell {
                    self.configureCell(cell, atIndexPath: updatedIndexPath)
            }
            
        case .Move:
            if let deletedIndexPath = indexPath {
                self.tableView!.deleteRowsAtIndexPaths([deletedIndexPath], withRowAnimation: .Automatic)
            }
            if let newIndexPath = newIndexPath {
                self.tableView!.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView!.endUpdates()
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("EntryCell", forIndexPath: indexPath) as! EntryTableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: Configure cell
    
    func configureCell(cell: EntryTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let entry = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Entry
        
        cell.title = entry?.title
        cell.summary = entry?.textSummary
        cell.author = entry?.author
        
        if let thumbnail = entry?.thumbnail {
            cell.thumbnail = UIImage(data: thumbnail)
        } else {
            cell.thumbnail = nil
        }
        
        if let unread = entry?.unread {
            cell.unread = unread
        } else {
            cell.unread = false
        }
        
        //cell.layoutIfNeeded()
    }
    
    // MARK DZNEmptyDataSet
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSAttributedString(string: "Nothing to show")
        return title
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let description = NSAttributedString(string: "No feeds here. Try to refresh.")
        
        return description
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        return NSAttributedString(string: "Refresh")
    }
    
    // MARK DZNEmptyDataSet Delegate
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        self.refresh()
    }
}