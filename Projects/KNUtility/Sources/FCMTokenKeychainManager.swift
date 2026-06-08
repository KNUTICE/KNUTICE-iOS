//
//  FCMTokenKeychainManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/13/25.
//

import Foundation
import Security

public actor FCMTokenKeychainManager {
    
    // MARK: - Properties
    
    public static let shared: FCMTokenKeychainManager = .init()
    
    private init() {}
    
    // MARK: - Public Methods

    /// Saves the given FCM token to the Keychain.
    ///
    /// This method first removes any existing token by calling `delete()` and then inserts
    /// the new token using `create(for:)`. Since this method contains no `await` points,
    /// it executes synchronously within the actor's context, ensuring atomicity without
    /// interleaved execution.
    ///
    /// - Parameter token: The FCM token string to be stored.
    /// - Returns: `true` if successfully saved, otherwise `false`.
    ///
    /// - Warning: This method performs synchronous, blocking disk I/O operations underneath.
    ///   Calling this from the `MainActor` (e.g., UI Thread) will block the main thread
    ///   until the operation completes. To prevent UI freezes, invoke this method from
    ///   a background context, such as `Task.detached`.
    @discardableResult
    public func save(fcmToken token: String) -> Bool {
        // Remove existing token before saving
        delete()
        // Save token
        return create(for: token)
    }
    
    /// Reads the stored FCM token from the Keychain.
    ///
    /// This method performs a synchronous Keychain lookup isolated within the actor.
    /// When called from outside the actor, it must be invoked asynchronously using `await`.
    ///
    /// - Returns: The stored FCM token string, or `nil` if the item does not exist,
    ///   the query fails, or the data cannot be decoded as UTF-8.
    ///
    /// - Important:
    ///   - Uses `kSecAttrAccessibleAfterFirstUnlock`, allowing token access even during
    ///     background execution once the device has been unlocked for the first time.
    ///
    /// - Warning: Keychain access is a blocking system call. Even though it is marked with `await`
    ///   from the caller's perspective due to actor isolation, the underlying execution will still
    ///   block the caller's thread. It is highly recommended to call this within a `Task.detached`
    ///   context if invoked from the main UI thread.
    public func read() -> String? {
        let query = baseQuery(returnData: true)
        var item: AnyObject?
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard result == errSecSuccess, let data = item as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Private Methods
    
    /// Deletes the stored FCM token from the Keychain.
    ///
    /// This method performs a synchronous `SecItemDelete` operation, blocking the current
    /// actor executor until the deletion is complete.
    ///
    /// - Returns: `true` if the item was successfully deleted or did not exist, otherwise `false`.
    @discardableResult
    private func delete() -> Bool {
        let query = baseQuery()
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
    
    /// Creates a new Keychain item for the given FCM token.
    ///
    /// This method uses the `kSecClassGenericPassword` class to securely store the token
    /// data. Since duplicate keys will cause `SecItemAdd` to fail, any existing item
    /// must be deleted prior to calling this method.
    ///
    /// - Parameter token: The FCM token string to be stored.
    /// - Returns: `true` if the `SecItemAdd` operation returns `errSecSuccess`, otherwise `false`.
    @discardableResult
    private func create(for token: String) -> Bool {
        let query = baseQuery()
        query[kSecValueData as String] = token.data(using: .utf8)!
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    /// Generates the base query dictionary configured for FCM token Keychain operations.
    ///
    /// - Parameter returnData: If `true`, adds the `kSecReturnData` key to the dictionary.
    /// - Returns: An `NSMutableDictionary` containing the standard query attributes.
    private func baseQuery(returnData: Bool = false) -> NSMutableDictionary {
        let attrLabel: String = "fcmToken"
        let serviceName: String = "KNUTICE"
        let accessGroup: String = Bundle.knUtility.teamId + ".com.fx.KNUTICE"
        let query: NSMutableDictionary = [
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecClass: kSecClassGenericPassword,
            kSecAttrLabel: attrLabel,
            kSecAttrService: serviceName,
            kSecAttrAccessGroup: accessGroup
        ]
        
        if returnData {
            query[kSecReturnData] = true
        }
        
        return query
    }
}
