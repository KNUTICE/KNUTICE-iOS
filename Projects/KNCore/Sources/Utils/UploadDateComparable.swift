//
//  UploadDateComparable.swift
//  KNCore
//
//  Created by 이정훈 on 4/21/26.
//

import Foundation

protocol UploadDateComparable {
    func isWithin24Hours(from dateString: String) -> Bool
}

extension UploadDateComparable {
    func isWithin24Hours(from dateString: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString) ?? Date.distantPast
        
        return abs(date.timeIntervalSince1970) < 86400
    }
}
