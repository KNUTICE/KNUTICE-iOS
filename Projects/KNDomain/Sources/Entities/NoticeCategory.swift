//
//  NoticeCategory.swift
//  KNNotice
//
//  Created by 이정훈 on 1/2/26.
//

import Foundation
import KNUtility

public enum NoticeCategory: String {
    case generalNotice = "GENERAL_NEWS"
    case academicNotice = "ACADEMIC_NEWS"
    case scholarshipNotice = "SCHOLARSHIP_NEWS"
    case eventNotice = "EVENT_NEWS"
    case employmentNotice = "EMPLOYMENT_NEWS"
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
}

// MARK: - NoticeTabRepresentable
extension NoticeCategory: NoticeTabRepresentable {
    public var id: String { self.rawValue }
    
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
