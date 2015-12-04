
import Foundation

class Alerts {
    
    /// Display an error on a view controller.
    internal class func displayError(message: String, onUIViewController viewController: UIViewController) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}