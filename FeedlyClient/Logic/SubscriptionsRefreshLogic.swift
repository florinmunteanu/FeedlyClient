
import Foundation
import CoreData

internal class SubscriptionsRefreshLogic {
    
    internal var success: () -> Void
    
    internal var failure: (error: NSError) -> Void
    
    private let accessToken: String
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(accessToken: String, managedObjectContext: NSManagedObjectContext) {
        self.success = { () -> Void in }
        self.failure = { (error: NSError) -> Void in }
        
        self.accessToken = accessToken
        self.managedObjectContext = managedObjectContext
    }
    
    internal func run() {
        self.beginLoadCategories(
            self.accessToken,
            success: {
                (categories: [FeedlyCategory]) -> Void in
                let updateResult = self.tryUpdateCategories(categories)
                
                if updateResult.succeeded {
                    self.beginLoadSubscriptions(self.accessToken)
                } else {
                    self.failure(error: self.createNSError(updateResult.error!))
                }
        })
    }
    
    private func beginLoadCategories(accessToken: String, success: (categories: [FeedlyCategory]) -> Void) {
        FeedlyCategoriesRequests.beginGetCategories(
            accessToken,
            success: {
                (categories: [FeedlyCategory]) -> Void in
                success(categories: categories)
            },
            failure: {
                (error: NSError) -> Void in
                self.failure(error: error)
        })
    }
    
    private func tryUpdateCategories(categories: [FeedlyCategory]) -> (succeeded: Bool, error: ErrorType?) {
        do {
            try self.updateCategories(categories)
        } catch {
            return (false, error)
        }
        
        return (true, nil)
    }
    
    private func updateCategories(categories: [FeedlyCategory]) throws {
        try Category.deleteAllCategories(inManagedObjectContext: self.managedObjectContext)
        
        for category in categories {
            try Category.getOrAdd(category, inManagedObjectContext: self.managedObjectContext)
        }
    }
    
    private func beginLoadSubscriptions(accessToken: String) {
        FeedlySubscriptionsRequests.beginGetSubscriptions(
            accessToken,
            success: {
                (subscriptions: [FeedlySubscription]) -> Void in
                
                let result = self.tryUpdateSubscriptions(subscriptions)
                if result.succeeded {
                    self.success()
                } else {
                    self.failure(error: self.createNSError(result.error!))
                }
            },
            failure: {
                (error: NSError) -> Void in
                self.failure(error: error)
        })
    }
    
    private func tryUpdateSubscriptions(subscriptions: [FeedlySubscription]) -> (succeeded: Bool, error: ErrorType?) {
        do {
            try self.updateSubscriptions(subscriptions)
        } catch {
            return (false, error)
        }
        
        return (true, nil)
    }
    
    private func updateSubscriptions(subscriptions: [FeedlySubscription]) throws {
        for subscription in subscriptions {
            try Subscription.addOrUpdate(subscription, inManagedObjectContext: self.managedObjectContext)
        }
    }
    
    private func createNSError(error: ErrorType) -> NSError {
        return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
    }
}