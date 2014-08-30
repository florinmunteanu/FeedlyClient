
import Foundation

///  Defines an access token used to access the Feedly API
///
class RefreshAccessToken {
    
    init(json: Dictionary<String, String>) {
        if let userId = json[AuthParameters.userId] {
            self.userId = userId
        }
        if let accessToken = json[AuthParameters.accessToken] {
            self.accessToken = accessToken
        }
        if let expiresIn = json[AuthParameters.expiresIn] {
            if let intValue = expiresIn.toInt() {
                self.expiresIn = intValue
            }
        }
        if let tokenType = json[AuthParameters.tokenType] {
            self.tokenType = tokenType
        }
        if let plan = json[AuthParameters.plan] {
            self.plan = plan
        }
    }
    
    var userId: String = ""
    
    var accessToken: String = ""
    
    var expiresIn: Int = 0
    
    var tokenType: String = ""
    
    var plan: String = ""
}