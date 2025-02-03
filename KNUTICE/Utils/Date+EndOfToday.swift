//
//  Date+EndOfToday.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/24/25.
//

import Foundation

extension Date {
    static var endOfToday: Date? {
        let now = Date()
        let calendar = Calendar.current
        var dateComponent = calendar.dateComponents([.year, .month, .day], from: now)
        dateComponent.hour = 23
        dateComponent.minute = 59
        dateComponent.second = 59
        
        return calendar.date(from: dateComponent)
    }
}
