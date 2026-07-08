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
    
    public var id: Int {
        switch self {
        case .studentCafeteria:
            return 900
        case .staffCafeteria:
            return 901
        }
    }
    
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
    
    public init?(id: Int) {
        switch id {
        case 900:
            self = .studentCafeteria
        case 901:
            self = .staffCafeteria
        default:
            return nil
        }
    }
}
