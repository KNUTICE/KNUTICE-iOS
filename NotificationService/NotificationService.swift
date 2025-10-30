//
//  NotificationService.swift
//  NotificationService
//
//  Created by 이정훈 on 8/9/24.
//

import KNUTICECore

final class NotificationService: KNUTICENotificationService, @unchecked Sendable {
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
