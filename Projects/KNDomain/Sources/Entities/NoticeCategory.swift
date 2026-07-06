//
//  NoticeCategory.swift
//  KNNotice
//
//  Created by 이정훈 on 1/2/26.
//

import Foundation
import KNUtility

public enum NoticeCategory: String, CaseIterable {
    case generalNotice = "GENERAL_NEWS"
    case academicNotice = "ACADEMIC_NEWS"
    case scholarshipNotice = "SCHOLARSHIP_NEWS"
    case eventNotice = "EVENT_NEWS"
    case employmentNotice = "EMPLOYMENT_NEWS"
    
    public init?(id: Int) {
        switch id {
        case 1:
            self = .generalNotice
        case 2:
            self = .academicNotice
        case 3:
            self = .scholarshipNotice
        case 4:
            self = .eventNotice
        case 5:
            self = .employmentNotice
        default:
            return nil
        }
    }
    
    public var id: Int {
        switch self {
        case .generalNotice:
            return 1
        case .academicNotice:
            return 2
        case .scholarshipNotice:
            return 3
        case .eventNotice:
            return 4
        case .employmentNotice:
            return 5
        }
    }
    
    public static func id(fromRawValue rawValue: String) -> Int? {
        NoticeCategory(rawValue: rawValue)?.id
    }
    
    public static func rawValue(fromID id: Int) -> String? {
        NoticeCategory(id: id)?.rawValue
    }
}

// MARK: - CategoryProtocol
extension NoticeCategory: CategoryProtocol {
    public var localizedDescription: String {
        switch self {
        case .generalNotice:
            return "일반소식"
        case .academicNotice:
            return "학사공지"
        case .scholarshipNotice:
            return "장학공지"
        case .eventNotice:
            return "행사안내"
        case .employmentNotice:
            return "취업안내"
        }
    }
    
    public var topic: String {
        return self.rawValue
    }
}

// MARK: - NoticeTabRepresentable
extension NoticeCategory: NoticeTabRepresentable {
    public var tabTitle: String {
        switch self {
        case .generalNotice:
            return "일반"
        case .academicNotice:
            return "학사"
        case .scholarshipNotice:
            return "장학"
        case .eventNotice:
            return "행사"
        case .employmentNotice:
            return "취업"
        }
    }
}
