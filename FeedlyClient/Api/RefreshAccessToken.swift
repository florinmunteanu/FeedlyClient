
import Foundation

class RefreshAccessToken {
    
    init() {
        
    }
    
    init(json: Dictionary<String, String>) {
        if let userId = json[APIParameters.userId] {
            self.userId = userId
        }
        if let accessToken = json[APIParameters.accessToken] {
            self.accessToken = accessToken
        }
        if let expiresIn = json[APIParameters.expiresIn] {
            if let intValue = expiresIn.toInt() {
                self.expiresIn = intValue
            }
        }
        if let tokenType = json[APIParameters.tokenType] {
            self.tokenType = tokenType
        }
        if let plan = json[APIParameters.plan] {
            self.plan = plan
        }
    }
    
    var userId: String = ""
    
    var accessToken: String = ""
    
    var expiresIn: Int = 0
    
    var tokenType: String = ""
    
    var plan: String = ""
}