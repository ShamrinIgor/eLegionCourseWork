import Foundation
import LocalAuthentication

// MARK: - Keychain methods

extension LoginScreenViewController {
    private func keyChainQuery(service: String, account: String? = nil) -> [String: AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecAttrService as String] = service as AnyObject
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject
        }
        
        return query
    }
    
    func readPassword(service: String, account: String?) -> String? {
        var query = keyChainQuery(service: service, account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String: AnyObject],
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) else {
                return nil
        }
        
        return password
    }
    
    func savePassword(password: String, service: String, account: String?) -> Bool {
        let passwordData = password.data(using: .utf8)
        
        if readPassword(service: service, account: account) != nil {
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = passwordData as AnyObject
            
            let query = keyChainQuery(service: service, account: account)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        var item = keyChainQuery(service: service, account: account)
        item[kSecValueData as String] = passwordData as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
    
    func readAllItems(service: String) -> [String : String]? {
        var query = keyChainQuery(service: service)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        guard status == noErr else {
            return nil
        }
        
        guard let items = queryResult as? [[String : AnyObject]] else {
            return nil
        }
        var passwordItems = [String : String]()
        
        for (index, item) in items.enumerated() {
            guard let passwordData = item[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: .utf8) else {
                    continue
            }
            
            if let account = item[kSecAttrAccount as String] as? String {
                passwordItems[account] = password
                continue
            }
            
            let account = "empty account \(index)"
            passwordItems[account] = password
        }
        
        return passwordItems
    }
    
    
    func authenticateUser(account: String, password: String) {
        
        if #available(iOS 8.0, *, *) {
            let authenticationContext = LAContext()
            setupAuthencticationContext(context: authenticationContext)
            
            let reason = "Fast and safe authentication in your app"
            var authError: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, evaluateError in
                    if success {
                        self.logInIntoAccount(account: account, password: password)
                    } else {
                        
                        if let error = evaluateError {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                if let error = authError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func deletePassword(service: String, accout: String?) -> Bool {
        let item = keyChainQuery(service: service, account: accout)
        let status = SecItemDelete(item as CFDictionary)
        return status == noErr
    }
    
    
    func setupAuthencticationContext(context: LAContext) {
        context.localizedReason = "Use for fast and safe authentication in your app"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Enter password"
    }
    
}
