
import Foundation

///  Defines an access token used to access the Feedly API
///
class FeedlyRefreshAccessToken {
    
    init(json: Dictionary<String, AnyObject>) {
        if let userId = json[FeedlyAuthParameters.userId] as? String{
            self.userId = userId
        }
        if let accessToken = json[FeedlyAuthParameters.accessToken] as? String {
            self.accessToken = accessToken
        }
        if let expiresIn = json[FeedlyAuthParameters.expiresIn] as? Int64 {
            self.expiresIn = expiresIn
        }
        if let tokenType = json[FeedlyAuthParameters.tokenType] as? String {
            self.tokenType = tokenType
        }
        if let plan = json[FeedlyAuthParameters.plan] as? String{
            self.plan = plan
        }
    }
    
    var userId: String = ""
    
    var accessToken: String = ""
    
    var expiresIn: Int64 = 0
    
    var tokenType: String = ""
    
    var plan: String = ""
}