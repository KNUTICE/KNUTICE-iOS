//
//  NotificationPermissionUpdateDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//
import Foundation

// MARK: - NotificationPermissionUpdateDTO
struct NotificationPermissionUpdateDTO: Decodable {
    let result: RequestResult
    let body: NotificationPermissionUpdateBody?
}

// MARK: - Body
struct NotificationPermissionUpdateBody: Decodable {
    let message: String
}
