
class KeychainData {
    
    init() {
        
    }
    
    var accessToken: String?
    
    var refreshToken: String?
    
    var userName: String = ""
    
    func toJson() throws -> NSData {
        
        let dictionary = [
            "accessToken"  : self.accessToken ?? "",
            "refreshToken" : self.refreshToken ?? "",
            "userName"     : self.userName
        ]
        
        let data = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
        
        return data
    }
    
    class func fromJson(data: NSData?) throws -> KeychainData {
        
        var keychainDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! Dictionary<String, AnyObject>
        
        let keychain = KeychainData()
        
        keychain.accessToken = keychainDict["accessToken"] as AnyObject? as? String
        
        if keychain.accessToken == "" {
            keychain.accessToken = nil
        }
        
        keychain.refreshToken = keychainDict["refreshToken"] as AnyObject? as? String
        
        if keychain.refreshToken == "" {
            keychain.refreshToken = nil
        }
        
        keychain.userName = keychainDict["userName"] as! String
        
        return keychain
    }
}
