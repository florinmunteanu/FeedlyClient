
import Foundation

///  Defines an access token used to access the Feedly API
///
class UserAccessToken {
    
    /// Initialize an access token using a dictionary with values received from JSON call made to Feedly auth
    init(json: Dictionary<String, AnyObject>) {
        if let id = json[AuthParameters.userId] as AnyObject? as? String {
            self.userId = id
        }
        if let accessToken = json[AuthParameters.accessToken] as AnyObject? as? String {
            self.accessToken = accessToken
        }
        if let expiresIn = json[AuthParameters.expiresIn] as AnyObject? as? String {
            if let intValue = expiresIn.toInt() {
                self.expiresIn = intValue
            }
        }
        if let state = json[AuthParameters.state] as AnyObject? as? String {
            self.state = state
        }
        if let refreshToken = json[AuthParameters.refreshToken] as AnyObject? as? String {
            self.refreshToken = refreshToken
        }
        if let tokenType = json[AuthParameters.tokenType] as AnyObject? as? String {
            self.tokenType = tokenType
        }
        if let plan = json[AuthParameters.plan] as AnyObject? as? String {
            self.plan = plan
        }
    }
    
    /// Standard plan String
    var standardPlan = "standard"
    
    /// Pro plan String
    var proPlan = "pro"
    
    /// Feedly user id
    var userId: String = ""
    
    /// A token that may be used to obtain a new access token. Refresh tokens are valid until the user revokes access.
    var refreshToken: String = ""
    
    /// A token that may be used to access APIs. Access tokens are have an expiration.
    var accessToken: String = ""
    
    /// Indicated the user plan (standard or pro).
    var plan: String = ""
    
    /// The remaining lifetime on the access token.
    var expiresIn: Int = 0
    
    /// Indicates the type of token returned. At this time, this field will always have the value of Bearer.
    var tokenType: String = ""
    
    var state: String = ""
}