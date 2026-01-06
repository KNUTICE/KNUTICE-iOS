//
//  Date+SpecificTime.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/4/25.
//

import Foundation

extension Date {
    static var tenPM: Date {
        let calendar = Calendar.current
        var tenPMComponents = DateComponents()
        tenPMComponents.hour = 22
        tenPMComponents.minute = 0
        tenPMComponents.second = 0
        
        guard let date = calendar.date(from: tenPMComponents) else {
            fatalError("Couldn't create Date from DateComponents")
        }
        
        return date
    }
    
    static var eightAM: Date {
        let calendar = Calendar.current
        var eightAMComponents = DateComponents()
        eightAMComponents.hour = 8
        eightAMComponents.minute = 0
        eightAMComponents.second = 0
        
        guard let date = calendar.date(from: eightAMComponents) else {
            fatalError("Couldn't create Date from DateComponents")
        }
        
        return date
    }
}
