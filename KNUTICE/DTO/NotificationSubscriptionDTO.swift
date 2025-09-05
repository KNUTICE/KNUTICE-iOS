//
//  NotificationSubscriptionDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/30/25.
//

import Foundation
import KNUTICECore

// MARK: - NotificationSubscriptionDTO
struct NotificationSubscriptionDTO: Decodable {
    let result: RequestResult
    let body: NotificationSubscriptionBody
}

// MARK: - Body
struct NotificationSubscriptionBody: Decodable {
    let generalNewsTopic, scholarshipNewsTopic, eventNewsTopic, academicNewsTopic: Bool
    let employmentNewsTopic: Bool
}
