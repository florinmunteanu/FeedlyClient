
import Foundation
import CoreData

class CategoryEntriesTableViewController: UITableViewController,  NSFetchedResultsControllerDelegate {
    
    //private let reuseIdentifier = "MyCollectionViewCell"
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var categoryId: String? = "6"
    
    var categoryName: String? {
        didSet {
            self.title = self.categoryName
        }
    }
    
    // A dictionary of offscreen cells that are used within the sizeForItemAtIndexPath method to handle the size calculations. These are never drawn onscreen. The dictionary is in the format:
    // { NSString *reuseIdentifier : UICollectionViewCell *offscreenCell, ... }
    //var offscreenCells = Dictionary<String, UICollectionViewCell>()
    
    //let kHorizontalInsets: CGFloat = 5.0
    //let kVerticalInsets: CGFloat = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let refreshControl = UIRefreshControl()
        //self.refreshControl = UIRefreshControl()
        //self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        //self.refreshControl = refreshControl
        //self.collectionView!.addSubview(refreshControl)
        //self.collectionView!.alwaysBounceVertical = true
        
        //let myCellNib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        //self.collectionView!.registerNib(myCellNib, forCellWithReuseIdentifier: self.reuseIdentifier)
        
        //self.tableView!.addSubview(refreshControl)
        //self.tableView!.alwaysBounceVertical = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        self.refreshControl = refreshControl
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 75
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        if self.categoryId != nil {
            self.beginLoadStream(categoryId!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Entry" {
            let entryViewController = segue.destinationViewController as! EntryViewController
            
            if let selectedCell = sender as? EntryTableViewCell {
                if let indexPath = self.tableView!.indexPathForCell(selectedCell) {
                    let entry = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Entry
                    entryViewController.selectedEntry = entry
                    entryViewController.entries = [entry]
                }
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
    
    // MARK: UICollectionViewDataSource
    /*
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let sectionInfo = self.fetchedResultsController.sections![section]
    return sectionInfo.numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as EntryCollectionViewCell
    //self.configureCell(cell, atIndexPath: indexPath)
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
    self.configureCell(cell, atIndexPath: indexPath)
    
    return cell
    }
    */
    // MARK: UICollectionViewDelegateFlowLayout
    
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as? MyCollectionViewCell
        //self.configureCell(cell, atIndexPath: indexPath)
        //if cell != nil {
        //    cell!.setNeedsLayout()
        //    cell!.layoutIfNeeded()
        //}
        //var size: CGSize = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        //size.width = ceil(size.width)
        //size.height = ceil(size.height)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return CGSize(width: self.collectionView!.frame.width, height: 200)
            //return size
        } else {
            return CGSize(width: self.collectionView!.frame.width, height: 75)
        }
        // Set up desired width
        //let targetWidth: CGFloat = (collectionView.bounds.width - 3 * kHorizontalInsets) / 2
        
        //let targetWidth: CGFloat = 200
        
        // Use fake cell to calculate height
        //let reuseIdentifier = self.reuseIdentifier
        //var cell: MyCollectionViewCell? = self.offscreenCells[reuseIdentifier] as? MyCollectionViewCell
        //if cell == nil {
        //    cell = NSBundle.mainBundle().loadNibNamed("MyCollectionViewCell", owner: self, options: nil)[0] as? MyCollectionViewCell
        //self.offscreenCells[reuseIdentifier] = cell
        //}
        
        // Config cell and let system determine size
        //cell!.configCell(titleData[indexPath.item], content: contentData[indexPath.item], titleFont: fontArray[indexPath.item] as String, contentFont: fontArray[indexPath.item] as String)
        
        //self.configureCell(cell!, atIndexPath: indexPath)
        
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        //cell!.bounds = CGRectMake(0, 0, targetWidth, cell!.bounds.height)
        //cell!.contentView.bounds = cell!.bounds
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        //cell!.setNeedsLayout()
        //cell!.layoutIfNeeded()
        
        //var size = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        //size.width = targetWidth
        //return size
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
*/    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        //self.collectionView!.beginUpdates()
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
            self.tableView!.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            self.tableView!.deleteRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            //case .Update:
            //if let cell = tableView.cellForRowAtIndexPath(indexPath) as? EntryTableViewCell {
            //    self.configureCell(cell, atIndexPath: indexPath)
            //}
            //self.configureCell(self.tableView(self.tableView, cellForRowAtIndexPath: indexPath), atIndexPath: indexPath)
            //self.configureCell(tableView.cellForRowAtIndexPath(indexPath)! as EntryTableViewCell, atIndexPath: indexPath)
        case .Move:
            self.tableView!.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            self.tableView!.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        //self.collectionView!.
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //var cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        //var entry: AnyObject! = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Entry
        //self.performSegueWithIdentifier("Entry", sender: entry)
    }
    
    // MARK: UITableViewDelegate
    /*
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    
    }
    */
    
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
        //cell.layoutIfNeeded()
    }
    
    /*
    func configureCell(cell: MyCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
    let entry = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Entry
    
    var title = ""
    var content = ""
    if let t = entry?.title {
    title = t
    }
    if let c = entry?.textSummary {
    content = c
    }
    cell.configCell(title, content: content)
    //cell.titleLabel.text = entry?.title
    //cell.subtitleLabel.text = entry?.textSummary
    //cell.contentLabel.text = entry?.textSummary
    
    //cell.titleLabel.text = entry?.title
    //cell.summaryLabel.text = entry?.textSummary
    //cell.authorLabel.text = entry?.author
    //cell.thumbnailImageView.image
    }*/
}