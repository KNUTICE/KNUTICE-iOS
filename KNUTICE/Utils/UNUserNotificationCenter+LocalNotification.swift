//
//  UNUserNotificationCenter+LocalNotification.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/18/25.
//

import Combine
import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    /// 새로운 Bookmark 알림 생성
    func registerLocalNotification(for bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return Future { promise in
            guard let date = bookmark.alarmDate else {
                //알람이 설정되지 않은 경우 즉시 반환
                promise(.success(()))
                return
            }
            
            Task {
                let pendingNotificationRequests = await self.pendingNotificationRequests()
                let insertionIndex = pendingNotificationRequests.rightInsertionIndex(for: date)
                let content = self.createNotificationContent(body: bookmark.notice.title, badge: insertionIndex + 1)
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)    //알림 날짜
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)    //알림 시점, 반복 여부 설정
                let notificationRequest = UNNotificationRequest(
                    identifier: String(bookmark.notice.id),
                    content: content,
                    trigger: trigger
                )
                
                do {
                    //새로운 NotificationRequest 추가
                    try await self.add(notificationRequest)
                    //기존 NotificationRequest Badge 업데이트
                    try await self.modifyNotificationBadges(
                        pendingNotificationRequests,
                        startingAt: insertionIndex,
                        by: +
                    )
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func createNotificationContent(body: String, badge: Int) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "북마크 알림"
        content.body = body
        content.sound = .default
        content.badge = badge as NSNumber
        
        return content
    }
    
    func updatePendingNotificationRequestBadges() {
        Task {
            do {
                let requests = await pendingNotificationRequests()
                try await modifyNotificationBadges(requests, startingAt: 0, by: -)
            } catch {
                print("UNUserNotificationCenter.updatePendingNotificationRequestsBadge Error: \(error)")
            }
        }
    }
    
    private func modifyNotificationBadges(
        _ requests: [UNNotificationRequest],
        startingAt index: Int,
        by operation: (Int, Int) -> Int
    ) async throws {
        guard index < requests.count else { return }
        for request in requests[index...] {
            if let badge = request.content.badge as? Int {
                let badge = operation(badge, 1)
                let newContent = createNotificationContent(body: request.content.body, badge: badge)
                let newRequest = UNNotificationRequest(
                    identifier: request.identifier,
                    content: newContent,
                    trigger: request.trigger
                )
                try await add(newRequest)
            }
        }
    }
    
    func removeNotificationRequest(with identifier: String) {
        let identifiers: [String] = [identifier]
        self.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func removeNotificationRequest(from bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return Future { promise in
            Task {
                let pendingNotificationRequests = await self.pendingNotificationRequests()
                let pos = pendingNotificationRequests.firstIndex(of: .init(bookmark.notice.id))
                if let pos {
                    do {
                        try await self.modifyNotificationBadges(pendingNotificationRequests, startingAt: pos + 1, by: -)    //남아 있는 NotificationRequest Badge 업데이트
                        self.removeNotificationRequest(with: .init(bookmark.notice.id))
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                } else {
                    promise(.success(()))    //존재하지 않는 객체는 삭제 필요 없음
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

fileprivate extension Array where Element == UNNotificationRequest {
    /// NotificationRequest가 위치할 인덱스 반환
    func rightInsertionIndex(for targetDate: Date) -> Int {
        var pl = 0, pr = self.count - 1
        while pl <= pr {
            let pm = (pl + pr) / 2
            guard let trigger = self[pm].trigger as? UNCalendarNotificationTrigger,
                  let nextTriggerDate = trigger.nextTriggerDate() else {
                //비교할 nextTriggerDate가 존재하지 않는 경우, 가장 마지막 위치 반환
                return self.count
            }
            
            if nextTriggerDate <= targetDate {
                pl = pm + 1
            } else {
                pr = pm - 1
            }
        }
        
        return pl
    }
    
    func firstIndex(of identifier: String) -> Int? {
        for i in self.indices {
            if self[i].identifier == identifier {
                return i
            }
        }
        return nil
    }
}

public extension UNUserNotificationCenter {
    /// Remote Notification이 도착 후 Badge Count를 업데이트하는 메서드
    func updatePendingNotificationsBadge() async {
        let pendingNotificationRequests = await pendingNotificationRequests()
        guard !pendingNotificationRequests.isEmpty else { return }
        
        let deliveredNotifications = await deliveredNotifications()
        let count = deliveredNotifications.count + 1    //contentHandler가 호출될 때까지 count는 증가하지 않음
        
        pendingNotificationRequests.enumerated().forEach { (i, request) in
            let content = createNotificationContent(body: request.content.body, badge: count + 1 + i)
            let newRequest = UNNotificationRequest(
                identifier: request.identifier,
                content: content,
                trigger: request.trigger
            )
            
            self.add(newRequest)
        }
    }
}
