//
//  MajorNotificationManager.swift
//  KNUtility
//
//  Created by 이정훈 on 6/11/26.
//

import Foundation

@propertyWrapper
struct UserDefaultsMajorSubscription {
    private let storage = UserDefaults.shared
    private let key = UserDefaultsKeys.isMajorNotificationSubscribed.rawValue
    
    var wrappedValue: Bool {
        get {
            storage?.bool(forKey: key) ?? false
        }
        set {
            storage?.set(newValue, forKey: key)
        }
    }
    
}

public actor MajorNotificationManager {
    public static let shared = MajorNotificationManager()
    
    @UserDefaultsMajorSubscription private var storedSubscriptionState: Bool
    
    public var isSubscribed: Bool { storedSubscriptionState }
    
    private init() {}
    
    public func set(isSubscribed: Bool) {
        self.storedSubscriptionState = isSubscribed
    }
}
