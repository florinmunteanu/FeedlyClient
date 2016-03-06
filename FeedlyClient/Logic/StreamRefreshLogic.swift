
import Foundation
import CoreData

internal class StreamRefreshLogic {
    
    internal var success: () -> Void
    
    internal var failure: (error: NSError) -> Void
    
    private let refreshOptions: StreamRefreshOptions
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(refreshOptions: StreamRefreshOptions, managedObjectContext: NSManagedObjectContext){
        
        self.success = { () -> Void in }
        self.failure = { (error: NSError) -> Void in }
        
        self.refreshOptions = refreshOptions
        self.managedObjectContext = managedObjectContext
    }
    
    internal func run() {
        
    }
    
    internal func run(forCategory categoryId: String) {
        
        let options = FeedlyStreamSearchOptions()
        options.accessToken = self.refreshOptions.accessToken
        
        FeedlyStreamsRequests.beginGetStream(
            categoryId,
            options: options,
            success: {
                (stream: FeedlyStream) -> Void in
                if stream.entries.count > 0 {
                    self.beginLoadEntries(stream.entries)
                } else {
                    self.success()
                }
            },
            failure: {
                (error: NSError) -> Void in
                self.failure(error: error)
        });
    }
    
    private func beginLoadEntries(entries: [String]) {
        FeedlyEntriesRequests.beginGetEntries(entries,
            accessToken: self.refreshOptions.accessToken,
            success: {
                (entriesDictionary: Dictionary<String, FeedlyEntry>) -> Void in
                
                let updateResult = self.tryUpdateEntries(entriesDictionary)
                if updateResult.succeeded {
                    self.success()
                } else {
                    self.failure(error: self.createNSError(updateResult.error!))
                }
            },
            failure: {
                (error: NSError) -> Void in
                self.failure(error: error)
        })
    }
    
    private func tryUpdateEntries(entries: Dictionary<String, FeedlyEntry>) -> (succeeded: Bool, error: ErrorType?) {
        do {
            try self.updateEntries(entries)
        } catch {
            return (false, error)
        }
        
        return (true, nil)
    }
    
    private func updateEntries(entries: Dictionary<String, FeedlyEntry>) throws {
        for entry in entries {
            try self.updateEntry(entry)
        }
    }
    
    private func updateEntry(entry: (String, FeedlyEntry)) throws {
        try Entry.addOrUpdate(entry.1, inManagedObjectContext: self.managedObjectContext)
        
        if let visual = entry.1.visual {
            self.queueThumbnailDownload(visual.url, entryId: entry.1.id)
        }
    }
    
    private func queueThumbnailDownload(url: String, entryId: String) {
        ImagesDownloader.sharedInstance.queueImage(
            url,
            entryId: entryId,
            success: {
                (entryId, thumbnailImage) -> Void in
                self.tryUpdateThumbnail(thumbnailImage, entryId: entryId, numberOfRetries: 2)
        })
    }
    
    private func tryUpdateThumbnail(thumbnailImage: NSData, entryId: String, var numberOfRetries: uint = 2) {
        while numberOfRetries > 0 {
            do {
                try Entry.updateThumbnail(entryId, thumbnail: thumbnailImage, inManagedObjectContext: self.managedObjectContext)
                numberOfRetries = 0
            } catch {
                numberOfRetries--
            }
        }
    }
    
    private func createNSError(error: ErrorType) -> NSError {
        return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
    }
}
