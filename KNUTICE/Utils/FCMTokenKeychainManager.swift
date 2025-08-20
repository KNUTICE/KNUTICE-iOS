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
    
    /// Reads the stored FCM token from the Keychain.
    ///
    /// - Returns: The stored FCM token as a `String`, or `nil` if not found or decoding fails.
    /// - Important:
    ///   - If the Keychain item was saved with `kSecAttrAccessibleWhenUnlocked`,
    ///     this method will return `nil` when the device is locked (e.g., during a silent push or background execution).
    ///   - To ensure access in background or locked states, save the item with
    ///     `kSecAttrAccessibleAfterFirstUnlock` or `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`.
    /// - Note:
    ///   Uses a background queue to avoid blocking the main thread.
    func read() async -> String? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
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
            DispatchQueue.global(qos: .background).async {
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
            DispatchQueue.global(qos: .background).async {
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
        let attrLabel: String = "fcmToken"
        let serviceName: String = "KNUTICE"
        
        let query: NSMutableDictionary = [
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
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
