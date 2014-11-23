
import Foundation
import Security

// http://matthewpalmer.net/blog/2014/06/21/example-ios-keychain-swift-save-query/
// https://developer.apple.com/library/mac/documentation/security/Conceptual/keychainServConcepts/02concepts/concepts.html

// Identifiers
let serviceIdentifier = "FeedlyClient"
let userAccount = "authenticatedUser"

// Arguments for the keychain queries
let kSecClassValue = kSecClass as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecValueDataValue = kSecValueData as NSString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString

class KeychainService : NSObject {
    class func saveData(data: KeychainData) {
        var jsonData = data.toJson(nil)
        
        if jsonData != nil {
            self.save(serviceIdentifier, data: jsonData!)
        }
    }
    
    class func loadData() -> KeychainData? {
        return self.load(serviceIdentifier)
    }
    
    class func clearData() {
        var emptyData = KeychainData()
        KeychainService.saveData(emptyData)
    }
    
    /*
    *  Internal methods for querying the keychain.
    */
    private class func save(service: NSString, data: NSData) {
        // Instantiate a new default keychain query
        var keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, data], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionaryRef)
        
        // Add the new keychain item
        var status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)
    }
    
    private class func load(service: NSString) -> KeychainData? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        var keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef: Unmanaged<AnyObject>?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        
        if status == errSecSuccess {
            
            let opaque = dataTypeRef?.toOpaque()
            var contentsOfKeychain: KeychainData?
            
            if let op = opaque? {
                let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
                
                // Convert the data retrieved from the keychain into an instance of KeychainData
                
                contentsOfKeychain = KeychainData.fromJson(retrievedData, error: nil)
            } else {
                println("Nothing was retrieved from the keychain. Status code \(status)")
            }
            return contentsOfKeychain
        }
        
        return nil
    }
}