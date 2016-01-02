
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
    class func saveData(data: KeychainData) throws {
        let jsonData = try data.toJson()
        KeychainService.save(serviceIdentifier, data: jsonData)
    }
    
    class func loadData() throws -> KeychainData? {
        return try KeychainService.load(serviceIdentifier)
    }
    
    class func loadDataSafe() -> KeychainData {
        var keychainData: KeychainData?
        
        do {
            keychainData = try loadData()
        } catch {
        }
        
        if keychainData == nil {
            keychainData = KeychainData()
        }
        
        return keychainData!
    }
    
    class func clearData() throws {
        let emptyData = KeychainData()
        try KeychainService.saveData(emptyData)
    }
    
    /*
    *  Internal methods for querying the keychain.
    */
    private class func save(service: NSString, data: NSData) {
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, data], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionaryRef)
        
        // Add the new keychain item
        var status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)
    }
    
    private class func load(service: NSString) throws -> KeychainData? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = withUnsafeMutablePointer(&dataTypeRef) { SecItemCopyMatching(keychainQuery as CFDictionaryRef, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as? NSData
            // Convert the data retrieved from the keychain into an instance of KeychainData
            if retrievedData == nil {
                return nil
            }
            
            let contentsOfKeychain: KeychainData? = try KeychainData.fromJson(retrievedData)
            return contentsOfKeychain
        }
        
        return nil
    }
}