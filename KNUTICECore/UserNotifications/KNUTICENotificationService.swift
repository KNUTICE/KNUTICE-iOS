//
//  BaseNotificationService.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/8/25.
//

@preconcurrency import UserNotifications

open class KNUTICENotificationService: UNNotificationServiceExtension, @unchecked Sendable {
    open var contentHandler: ((UNNotificationContent) -> Void)?
    open var bestAttemptContent: UNMutableNotificationContent?
    
    open override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @Sendable @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent else {
            return
        }
        
        let imageData = request.content.userInfo["fcm_options"] as? [String: Any]
        let imageURLStr = imageData?["image"] as? String
        
        Task {
            let deliveredNotifications = await UNUserNotificationCenter.current().deliveredNotifications()
            bestAttemptContent.badge = (deliveredNotifications.count + 1) as NSNumber
            await UNUserNotificationCenter.current().updatePendingNotificationsBadgeAfterDelivered()    //Pending 되어 있는 알림 Badge 값 1씩 증가

            guard let imageURLStr else {
                //이미지가 없는 경우
                contentHandler(bestAttemptContent)
                return
            }
            
            //이미지가 있는 경우
            do {
                try self.saveFile(id: "notification_image.jpeg", imageURLString: imageURLStr) { fileURL in
                    do {
                        let attachment = try UNNotificationAttachment(identifier: "image_attachment", url: fileURL, options: nil)
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
}
