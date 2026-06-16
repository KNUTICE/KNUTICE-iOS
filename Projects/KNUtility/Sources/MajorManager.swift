//
//  MajorManager.swift
//  KNUtility
//
//  Created by 이정훈 on 4/14/26.
//

import Foundation

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

/// Manages the user's subscribed majors using persistent storage.
public actor MajorManager {
    
    /// Shared singleton instance.
    public static let shared = MajorManager()
    
    /// Persisted list of subscribed majors.
    @UserDefaultsMajors private var storedMajors: [String]
    
    /// Returns all currently subscribed majors.
    public var majorStrings: [String] { storedMajors }
    
    private init() {}
    
    /// Removes the specified major from the subscription list.
    ///
    /// - Parameter major: The major to remove.
    public func removeMajor(_ major: String) {
        var current = storedMajors
        current.removeAll { $0 == major }
        storedMajors = current
    }
    
    /// Adds a major to the subscription list if it does not already exist.
    ///
    /// - Parameter major: The major to add.
    public func addMajor(_ major: String) {
        var current = storedMajors
        
        guard !current.contains(major) else { return }
        
        current.append(major)
        storedMajors = current
    }
    
    /// Removes all subscribed majors.
    public func clearAll() {
        storedMajors = []
    }
}
