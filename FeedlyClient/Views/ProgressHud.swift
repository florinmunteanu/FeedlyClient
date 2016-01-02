
import Foundation

class ProgressHud {
    
    internal class func beginProgress() {
        SVProgressHUD.show()
    }
    
    internal class func reportProgress(progress: Float) {
        SVProgressHUD.showProgress(progress)
    }
    
    internal class func endProgress() {
        SVProgressHUD.dismiss()
    }
}