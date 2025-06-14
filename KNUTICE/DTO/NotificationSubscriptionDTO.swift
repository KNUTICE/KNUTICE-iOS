//
//  NotificationSubscriptionDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/30/25.
//

import Foundation

// MARK: - NotificationSubscriptionDTO
struct NotificationSubscriptionDTO: Codable {
    let result: RequestResult
    let body: NotificationSubscriptionBody
}

// MARK: - Body
struct NotificationSubscriptionBody: Codable {
    let generalNewsTopic, scholarshipNewsTopic, eventNewsTopic, academicNewsTopic: Bool
    let employmentNewsTopic: Bool
}
