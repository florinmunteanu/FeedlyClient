
import CoreData
import Foundation
import WebKit

class EntryViewController : UIViewController {
    
    var selectedEntry: Entry? = nil
    var entries: [Entry]? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    @IBOutlet weak var container: UIView!
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForInterfaceBuilder() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Entries" {
            let entriesPageViewController = segue.destinationViewController as? EntriesPageViewController
            if entriesPageViewController != nil {
                entriesPageViewController!.selectedEntry = self.selectedEntry
                entriesPageViewController!.entries = self.entries
                entriesPageViewController!.managedObjectContext = self.managedObjectContext
            }
        }
    }
}