//
//  TopicType.swift
//  KNUTICECore
//
//  Created by 이정훈 on 10/22/25.
//

import Foundation

public enum TopicType: String {
    case notice
    case major
    case meal
    
    public var rawValue: String {
        switch self {
        case .notice:
            return "NOTICE"
        case .major:
            return "MAJOR"
        case .meal:
            return "MEAL"
        }
    }
}
