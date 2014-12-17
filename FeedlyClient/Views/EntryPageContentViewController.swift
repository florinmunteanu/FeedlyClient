
import UIKit

class EntryPageContentViewController: UIViewController {

    var index: Int = 0
    var entry: Entry? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EntryWebView" {
            var entryWebViewController = segue.destinationViewController as? WebViewController
            if entryWebViewController != nil {
                entryWebViewController?.entry = self.entry
            }
        }
    }
}
