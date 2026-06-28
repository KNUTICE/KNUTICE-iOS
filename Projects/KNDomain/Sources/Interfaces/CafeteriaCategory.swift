//
//  CafeteriaCategory.swift
//  KNUtility
//
//  Created by 이정훈 on 2/27/26.
//

import Foundation

public enum CafeteriaCategory: String, CategoryProtocol {
    case studentCafeteria = "STUDENT_CAFETERIA"
    case staffCafeteria = "STAFF_CAFETERIA"
    
    public var localizedDescription: String {
        switch self {
        case .studentCafeteria:    
            return "학생 식당"
        case .staffCafeteria:
            return "교직원 식당"
        }
    }
    
    public var topic: String {
        return self.rawValue
    }
    
}
