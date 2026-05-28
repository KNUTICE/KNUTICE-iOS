//
//  UploadDateComparable.swift
//  KNData
//
//  Created by 이정훈 on 4/21/26.
//

import Foundation

public protocol UploadDateComparable {
    func isWithin48Hours(from dateString: String) -> Bool
}

public extension UploadDateComparable {
    func isWithin48Hours(from dateString: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")    // 사용자 설정에 의해 포맷이 변경될 수 있어, en_US_POSIX로 포맷 고정
        let date = formatter.date(from: dateString) ?? Date.distantPast
        
        return abs(Date().timeIntervalSince(date)) < 172_800    // 48시간(172800)초 보다 이내인지 확인
    }
}
