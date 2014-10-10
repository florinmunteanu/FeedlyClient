
import Foundation

class FeedlyUserProfile {
    
    init(json: Dictionary<String, AnyObject>) {
        
        if let userId = json["id"] as AnyObject? as? String {
            self.userId = userId
        }
        if let email = json["email"] as AnyObject? as? String {
            self.email = email
        }
        if let givenName = json["givenName"] as AnyObject? as? String {
            self.givenName = givenName
        }
        if let familyName = json["familyName"] as AnyObject? as? String {
            self.familyName = familyName
        }
        if let fullName = json["fullName"] as AnyObject? as? String {
            self.fullName = fullName
        }
        if let google = json["google"] as AnyObject? as? String {
            self.googleId = google
        }
        if let twitterUserId = json["twitterUserId"] as AnyObject? as? String {
            self.twitterId = twitterUserId
        }
        if let facebookUserId = json["facebookUserId"] as AnyObject? as? String {
            self.facebookId = facebookUserId
        }
        if let wordpressUserId = json["wordpressUserId"] as AnyObject? as? String {
            self.wordpressId = wordpressUserId
        }
        if let windowsLiveId = json["windowsLiveId"] as AnyObject? as? String {
            self.windowsLiveId = windowsLiveId
        }
        if let wave = json["wave"] as AnyObject? as? String {
            self.wave = wave
        }
        if let product = json["product"] as AnyObject? as? String {
            self.product = product
        }
        if let productExpiration = json["productExpiration"] as AnyObject? as? String {
            self.productExpiration = productExpiration
        }
        if let subscriptionStatus = json["subscriptionStatus"] as AnyObject? as? String {
            self.subscriptionStatus = subscriptionStatus
        }
        if let evernoteConnected = json["isEvernoteConnected"] as AnyObject? as? String {
            self.isEvernoteConnected = (evernoteConnected.lowercaseString == "true")
        }
        if let pocketConnected = json["isPocketConnected"] as AnyObject? as? String {
            self.isPocketConnected = (pocketConnected.lowercaseString == "true")
        }
    }
    
    /// The unique, immutable user id
    var userId: String = ""
    
    /// Optional string the email address extracted from the OAuth profile. Not always available, depending on the OAuth method used.
    var email: String = ""
    
    /// Optional string the given (first) name. Not always available.
    var givenName: String = ""
    
    /// Optional string the family (last) name. Not always available.
    var familyName: String = ""
    
    /// Optional string the full name. Not always available.
    var fullName: String = ""
    
    /// Optional string the Google user id, if the user went through Google’s OAuth flow.
    var googleId: String = ""
    
    /// Optional string the Twitter handle (legacy).
    //var twitter: String = ""
    
    /// Optional string the Twitter user id, if the user went through the Twitter OAuth flow.
    var twitterId: String = ""
    
    /// Optional string the Facebook user id, if the user went through the Facebook OAuth flow.
    var facebookId: String = ""
    
    /// Optional string the WordPress user id, if the user went through the WordPress OAuth flow.
    var wordpressId: String = ""
    
    /// Optional string the Windows Live user id, if the user went through the Windows Live OAuth flow.
    var windowsLiveId: String = ""
    
    /// string the analytics “wave”. Format is: “yyyy.ww” where yyyy is the year, ww is the week number. 
    /// E.g. “2014.02” means this user joined on the second week of 2014.
    /// See http://www.epochconverter.com/date-and-time/weeknumbers-by-year.php for week number definitions.
    var wave: String = ""
    
    /// Pro accounts only
    /// Optional string the feedly pro subscription. Values include FeedlyProMonthly, FeedlyProYearly, FeedlyProLifetime etc.
    var product: String = ""
    
    /// Pro accounts only
    /// Optional timestamp for expiring subscriptions only; the timestamp, in ms, when this subscription will expire.
    var productExpiration: String = ""
    
    /// Pro accounts only
    /// Optional string for expiring subscriptions only; values include Active, PastDue, Canceled, Unpaid, Deleted, Expired.
    var subscriptionStatus: String = ""
    
    /// Pro accounts only
    /// Optional boolean true if the user has activated the Evernote integration.
    var isEvernoteConnected: Bool = false
    
    /// Pro accounts only
    /// Optional boolean true if the user has activated the Pocket integration.
    var isPocketConnected: Bool = false
}