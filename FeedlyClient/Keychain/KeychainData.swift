
class KeychainData {
    
    init() {
        
    }
    
    var accessToken: String?
    
    var refreshToken: String?
    
    var userName: String = ""
    
    func toJson(error: NSErrorPointer) -> NSData? {
        
        var dictionary = [
            "accessToken"  : self.accessToken ?? "",
            "refreshToken" : self.refreshToken ?? "",
            "userName"     : self.userName
        ]
        
        var serializationError: NSError? = nil
        
        var data = NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted, error: &serializationError)
        
        if serializationError != nil && error != nil {
            error.memory = serializationError
        }
        return data
    }
    
    class func fromJson(data: NSData?, error: NSErrorPointer) -> KeychainData? {
        if data == nil {
            return nil
        }
        
        var deserializationError: NSError? = nil
        
        var keychainDict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &deserializationError) as! Dictionary<String, AnyObject>
        
        if deserializationError != nil && error != nil {
            error.memory = deserializationError
            return nil
        } else {
            var keychain = KeychainData()
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
}
