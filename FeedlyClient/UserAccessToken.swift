
import Foundation

class UserAccessToken {
    
    init() {
        
    }
    
    public var standardPlan = "standard"
    
    public var proPlan = "pro"
    
    // Feedly user id
    public var userId: String = ""
    
    // A token that may be used to obtain a new access token. Refresh tokens are valid until the user revokes access.
    public var refreshToken: String = ""
    
    // A token that may be used to access APIs. Access tokens are have an expiration.
    public var accessToken: String = ""
    
    // Indicated the user plan (standard or pro).
    public var plan: String = ""
    
    // The remaining lifetime on the access token.
    public var expiresIn: Int = 0
    
    // Indicates the type of token returned. At this time, this field will always have the value of Bearer.
    public var tokenType: String = ""
    
    public var state: String = ""
}