//
//  FCMTokenKeychainManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/13/25.
//

import Foundation
import Security

struct FCMTokenKeychainManager {
    //MARK: - Properties
    
    static let shared: FCMTokenKeychainManager = .init()
    
    private let attrLabel: String = "fcmToken"
    private let serviceName: String = "KNUTICE"
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Saves the given FCM token to the Keychain.
    ///
    /// - Parameter token: The FCM token string to be stored.
    /// - Returns: `true` if successfully saved, otherwise `false`.
    @discardableResult
    func save(fcmToken token: String) async -> Bool {
        await delete()    // Remove existing token before saving
        return await create(for: token)    //Save token
    }
    
    /// Reads a string value from the Keychain asynchronously.
    ///
    /// This method performs a `SecItemCopyMatching` query on a background thread to avoid blocking the main thread.
    /// It uses Swift's async/await with `withCheckedContinuation` to bridge the synchronous Keychain API into an async context.
    ///
    /// - Returns: The stored string value if found, otherwise `nil`.
    ///
    /// ## Note
    /// - Uses `DispatchQueue.global(qos: .default)` to execute the query off the main thread.
    /// - The `baseQuery(returnData: true)` must be configured to match the desired Keychain item.
    /// - Thread-safe: Keychain services are inherently thread-safe, but running on a background queue prevents UI freezes.
    /// - The returned string is UTF-8 decoded from the stored `Data`.
    func read() async -> String? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .default).async {
                var item: AnyObject?
                let result = SecItemCopyMatching(baseQuery(returnData: true), &item)
                
                guard result == errSecSuccess else {
                    continuation.resume(returning: nil)
                    return
                }
                
                guard let data = item as? Data else {
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: String(data: data, encoding: .utf8))
            }
        }
    }
    
    /// Deletes a Keychain item asynchronously.
    ///
    /// This method performs a `SecItemDelete` query on a background thread to avoid blocking the main thread.
    /// It uses Swift's async/await with `withCheckedContinuation` to bridge the synchronous Keychain API into an async context.
    ///
    /// - Returns: `true` if the item was successfully deleted, otherwise `false`.
    ///
    /// ## Note
    /// - Executes on `DispatchQueue.global(qos: .default)` to prevent UI blocking.
    /// - The `baseQuery()` must be configured to target the correct Keychain item.
    /// - Keychain services are thread-safe, but running on a background queue improves performance in UI-intensive environments.
    @discardableResult
    func delete() async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .default).async {
                continuation.resume(returning: SecItemDelete(baseQuery()) == errSecSuccess)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Saves the given FCM token to the Keychain.
    ///
    /// - Parameter token: The FCM token string to be stored.
    /// - Returns: A Boolean value indicating whether the token was successfully saved (`true`) or not (`false`).
    ///
    /// This method uses the `kSecClassGenericPassword` class to store the token
    /// with the specified service (`serviceName`) and label (`attrLabel`).
    /// If an item with the same attribute combination already exists,
    /// `SecItemAdd` will fail. To overwrite, use `SecItemUpdate`
    /// or delete the existing item before adding it again.
    ///
    /// - Note:
    ///   - The stored token is securely protected by the Keychain.
    ///   - The return value is `true` only if the `SecItemAdd` result code is `errSecSuccess`.
    @discardableResult
    private func create(for token: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .default).async {
                let saveQuery = baseQuery()
                saveQuery[kSecValueData] = token.data(using: .utf8)!
                
                continuation.resume(returning: SecItemAdd(saveQuery, nil) == errSecSuccess)
            }
        }
    }
    
    /// Generates a base query dictionary for Keychain operations.
    ///
    /// - Parameter returnData: If `true`, adds `kSecReturnData: true` to the query.
    /// - Returns: A mutable dictionary for Keychain queries.
    private func baseQuery(returnData: Bool = false) -> NSMutableDictionary {
        let query: NSMutableDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrLabel: attrLabel,
            kSecAttrService: serviceName
        ]
        
        if returnData {
            query[kSecReturnData] = true
        }
        
        return query
    }
}
