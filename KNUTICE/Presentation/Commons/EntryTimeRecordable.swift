//
//  EntryTimeRecordable.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/1/25.
//

import Combine
import Foundation
import UIKit

protocol EntryTimeRecordable {
    var foregroundPublisher: NotificationCenter.Publisher { get }
    func recordEntryTime()
    func timeIntervalSinceLastEntry() -> TimeInterval
}

extension EntryTimeRecordable {
    var foregroundPublisher: NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    }
    
    func recordEntryTime() {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: UserDefaultsKeys.entryTime.rawValue)
    }
    
    func timeIntervalSinceLastEntry() -> TimeInterval {
        let lastEntryTime = UserDefaults.standard.double(forKey: UserDefaultsKeys.entryTime.rawValue)
        
        return Date().timeIntervalSince1970 - lastEntryTime
    }
}
