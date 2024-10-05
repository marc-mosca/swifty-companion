//
//  KeychainService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 30/09/2024.
//

import Foundation

enum KeychainAccount: String {
    case applicationAccessToken
    case userAccessToken
    case userRefreshToken
}

final class KeychainService {
    static let shared: KeychainService = .init()
    
    private let service: String = "DASHBOARD42_KEYCHAIN_SERVICE"
    
    private init() {
    }
    
    func save(account: KeychainAccount, data: String) throws -> Void {
        let encodedData: Data = data.data(using: .utf8) ?? .init()
        let query: [String : AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecValueData as String: encodedData as AnyObject
        ]
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            try self.delete(account: account)
            return try self.save(account: account, data: data)
        }
        
        guard status == errSecSuccess else {
            throw Dashboard42Errors.runtimeError("An error occurred while saving the keychain item.")
        }
    }
    
    func get(account: KeychainAccount) -> String? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let _ = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data: Data = result as? Data else { return nil }
        
        return String(decoding: data, as: UTF8.self)
    }
    
    func delete(account: KeychainAccount) throws -> Void {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject
        ]
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw Dashboard42Errors.runtimeError("Failed to delete keychain item: \(status)")
        }
    }
    
    func clear() -> Void {
        try? self.delete(account: .applicationAccessToken)
        try? self.delete(account: .userAccessToken)
        try? self.delete(account: .userRefreshToken)
    }
}
