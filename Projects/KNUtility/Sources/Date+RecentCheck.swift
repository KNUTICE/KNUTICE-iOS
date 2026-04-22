//
//  Date+RecentCheck.swift
//  KNUtility
//
//  Created by 이정훈 on 4/21/26.
//

import Foundation

public extension Date {
    /// Returns whether the date is within 24 hours of the current time.
    var isWithin24Hours: Bool {
        abs(timeIntervalSince(self)) < 86400
    }
}
