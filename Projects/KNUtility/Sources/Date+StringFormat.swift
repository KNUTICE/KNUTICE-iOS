//
//  Date+StringFormat.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import Foundation

public extension Date {
    var shortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return dateFormatter.string(from: self)
    }
    
    var dateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh:mm"
        
        return dateFormatter.string(from: self)
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: self)
    }
}
