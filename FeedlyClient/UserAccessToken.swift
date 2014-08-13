
import Foundation

class UserAccessToken {
    
    init() {
        
    }
    
    init(json: Dictionary<String, String>) {
        if let id = json[APIParameters.userId] {
            self.userId = id
        }
        if let accessToken = json[APIParameters.accessToken] {
            self.accessToken = accessToken
        }
        if let expiresIn = json[APIParameters.expiresIn] {
            if let intValue = expiresIn.toInt() {
                self.expiresIn = intValue
            }
        }
        if let state = json[APIParameters.state] {
            self.state = state
        }
        if let refreshToken = json[APIParameters.refreshToken] {
            self.refreshToken = refreshToken
        }
        if let tokenType = json[APIParameters.tokenType] {
            self.tokenType = tokenType
        }
        if let plan = json[APIParameters.plan] {
            self.plan = plan
        }
    }
    
    var standardPlan = "standard"
    
    var proPlan = "pro"
    
    // Feedly user id
    var userId: String = ""
    
    // A token that may be used to obtain a new access token. Refresh tokens are valid until the user revokes access.
    var refreshToken: String = ""
    
    // A token that may be used to access APIs. Access tokens are have an expiration.
    var accessToken: String = ""
    
    // Indicated the user plan (standard or pro).
    var plan: String = ""
    
    // The remaining lifetime on the access token.
    var expiresIn: Int = 0
    
    // Indicates the type of token returned. At this time, this field will always have the value of Bearer.
    var tokenType: String = ""
    
    var state: String = ""
}