//
//  MajorManager.swift
//  KNUtility
//
//  Created by 이정훈 on 4/14/26.
//

import Foundation

@propertyWrapper
public struct UserDefaultMajors {
    private let storage = UserDefaults.shared
    private let storedMajorkey = UserDefaultsKeys.selectedMajor.rawValue
    
    /// The array of subscribed majors.
    /// Updating this value will immediately persist the new array to `UserDefaults`.
    public var wrappedValue: [String] {
        get {
            // Check for the modern format (String Array)
            if let value = storage?.stringArray(forKey: storedMajorkey) {
                return value
            }
            
            // allback to legacy format (Single String) for migration
            if let singleValue = storage?.string(forKey: storedMajorkey) {
                storage?.removeObject(forKey: storedMajorkey)
                storage?.set([singleValue], forKey: storedMajorkey)
                return [singleValue]
            }
            
            // Default fallback
            return []
        }
        set {
            storage?.set(newValue, forKey: storedMajorkey)
        }
    }
    
    public init() {}
}

public actor MajorManager {
    public static let shared = MajorManager()
    
    @UserDefaultMajors private var storedMajors: [String]
    
    public var majorStrings: [String] { storedMajors }
    
    private init() {}
    
    public func removeMajor(_ major: String) {
        var current = storedMajors
        current.removeAll { $0 == major }
        storedMajors = current
    }
    
    public func addMajor(_ major: String) {
        var current = storedMajors
        
        guard !current.contains(major) else { return }
        
        current.append(major)
        storedMajors = current
    }
    
    public func clearAll() {
        storedMajors = []
    }
}
