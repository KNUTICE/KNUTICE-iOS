//
//  MajorManager.swift
//  KNUtility
//
//  Created by 이정훈 on 4/14/26.
//

import Foundation

@available(iOS, deprecated: 17.0, message: "Use UserDefaultsMajorIDs instead.")
@available(macCatalyst, deprecated: 17.0, message: "Use UserDefaultsMajorIDs instead.")
@propertyWrapper
struct UserDefaultsMajors {
    private let storage = UserDefaults.shared
    private let key = UserDefaultsKeys.selectedMajor.rawValue
    
    /// The array of subscribed majors.
    /// Updating this value will immediately persist the new array to `UserDefaults`.
    var wrappedValue: [String] {
        get {
            // Check for the modern format (String Array)
            if let value = storage?.stringArray(forKey: key) {
                return value
            }
            
            // allback to legacy format (Single String) for migration
            if let singleValue = storage?.string(forKey: key) {
                storage?.set([singleValue], forKey: key)    // 기본 문자열 값을 문자열 배열로 마이그레이션
                return [singleValue]
            }
            
            // Default fallback
            return []
        }
        set {
            storage?.set(newValue, forKey: key)
        }
    }
    
}

@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
@propertyWrapper
struct UserDefaultsMajorIDs {
    private let storage = UserDefaults.shared
    private let key = UserDefaultsKeys.selectedMajor.rawValue
    
    /// The persisted array of subscribed major identifiers.
    ///
    /// Updating this value immediately writes the new array to `UserDefaults`.
    var wrappedValue: [Int] {
        get {
            storage?.array(forKey: key) as? [Int] ?? []
        }
        
        set {
            storage?.set(newValue, forKey: key)
        }
    }
}

/// Manages the user's subscribed majors using persistent storage.
public actor MajorManager {
    
    /// Shared singleton instance.
    public static let shared = MajorManager()
    
    /// The legacy string-based subscribed majors stored in `UserDefaults`.
    ///
    /// - Note: Retained for migration purposes. Prefer using `storedMajorIDs`.
    @UserDefaultsMajors
    private var storedMajors: [String]
    
    /// The persisted identifiers of the user's subscribed majors.
    @UserDefaultsMajorIDs
    private var storedMajorIDs: [Int]
    
    /// Returns the legacy string-based subscribed majors.
    ///
    /// - Note: This property is intended for migration only.
    public var majorStrings: [String] { storedMajors }
    
    /// Returns the identifiers of all subscribed majors.
    public var majorIDs: [Int] { storedMajorIDs }
    
    private init() {}
    
    /// Adds the specified major identifier to the subscription list if it is not already present.
    ///
    /// - Parameter id: The identifier of the major to subscribe to.
    public func add(id: Int) {
        var current = storedMajorIDs
        
        guard !current.contains(id) else { return }
        
        current.append(id)
        storedMajorIDs = current
    }
    
    public func remove(id: Int) {
        storedMajorIDs.removeAll { $0 == id }
    }
    
    /// Removes all subscribed majors.
    public func clearAll() {
        storedMajorIDs = []
    }
}
