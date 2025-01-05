//
//  Date+StringFormat.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import Foundation

extension Date {
    var shortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return dateFormatter.string(from: self)
    }
}
