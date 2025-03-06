//
//  NotificationService.swift
//  NotificationService
//
//  Created by 이정훈 on 8/9/24.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            guard let imageData = request.content.userInfo["fcm_options"] as? [String: Any],
                  let imageURLStr = imageData["image"] as? String else {
                contentHandler(bestAttemptContent)
                return
            }
            
            do {
                try saveFile(id: "notification_image.jpeg", imageURLString: imageURLStr) { fileURL in
                    do {
                        let attachment = try UNNotificationAttachment(identifier: "", url: fileURL, options: nil)
                        bestAttemptContent.attachments = [attachment]
                        contentHandler(bestAttemptContent)
                    } catch {
                        contentHandler(bestAttemptContent)
                    }
                }
            } catch {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    private func saveFile(id: String, imageURLString: String, completion: (URL) -> Void) throws {
        let fileManager = FileManager.default
        let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)    //Documents 디렉토리 URL 반환
        let fileURL = documentsDirectory.appendingPathComponent(id)    //URL에 이미지명을 추가
        
        //image의 url을 Data 타입으로 변환
        guard let imageURL = URL(string: imageURLString),
              let data = try? Data(contentsOf: imageURL) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        //Documents 폴더 아래 저장
        try data.write(to: fileURL)
        completion(fileURL)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
