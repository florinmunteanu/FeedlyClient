
import Foundation

///  Defines an access token used to access the Feedly API
///
class FeedlyRefreshAccessToken {
    
    init(json: Dictionary<String, String>) {
        if let userId = json[FeedlyAuthParameters.userId] {
            self.userId = userId
        }
        if let accessToken = json[FeedlyAuthParameters.accessToken] {
            self.accessToken = accessToken
        }
        if let expiresIn = json[FeedlyAuthParameters.expiresIn] {
            if let intValue = expiresIn.toInt() {
                self.expiresIn = intValue
            }
        }
        if let tokenType = json[FeedlyAuthParameters.tokenType] {
            self.tokenType = tokenType
        }
        if let plan = json[FeedlyAuthParameters.plan] {
            self.plan = plan
        }
    }
    
    var userId: String = ""
    
    var accessToken: String = ""
    
    var expiresIn: Int = 0
    
    var tokenType: String = ""
    
    var plan: String = ""
}