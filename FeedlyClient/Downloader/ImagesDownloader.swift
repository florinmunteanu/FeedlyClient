
import Foundation
import ImageIO

class ImagesDownloader {
    
    class var sharedInstance: ImagesDownloader {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : ImagesDownloader? = nil
        }
        dispatch_once(&Static.token) {
            Static.instance = ImagesDownloader()
        }
        return Static.instance!
    }
    
    let queue: NSOperationQueue = NSOperationQueue()
    
    init() {
        self.queue.maxConcurrentOperationCount = 2
    }
    
    func queueImage(imageUrl: String, entryId: String, success: (entryId: String, thumbnailImage: NSData)->Void) {
        if imageUrl == "" || imageUrl == "none" {
            return
        }
        
        self.queue.addOperationWithBlock({
            () -> Void in
            if let url = NSURL(string: imageUrl) {
                if let data = NSData(contentsOfURL: url) {
                    if let thumbnail = self.createThumbnail(data) {
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            () -> Void in
                            success(entryId: entryId, thumbnailImage: thumbnail)
                        })
                    }
                }
            }
        })
    }
    
    private func createThumbnail(data: NSData) -> NSData? {
        //http://nshipster.com/image-resizing/
        
        if let imageSource = CGImageSourceCreateWithData(data, nil) {
            let options : [String : AnyObject] = [
                kCGImageSourceThumbnailMaxPixelSize as String: 100,
                kCGImageSourceCreateThumbnailFromImageIfAbsent as String: true
            ]
            
            let scaledImage = UIImage(CGImage: CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)!)
            return UIImagePNGRepresentation(scaledImage)
        }
        return nil
    }
}