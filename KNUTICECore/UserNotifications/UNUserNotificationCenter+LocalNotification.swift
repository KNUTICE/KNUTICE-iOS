//
//  UNUserNotificationCenter+Badge.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/8/25.
//

import UserNotifications

extension UNUserNotificationCenter {
    /// 새로운 알림 추가
    public func scheduleNotification(for bookmark: Bookmark) async throws {
        // 알람이 설정되지 않은 경우 즉시 반환
        guard let date = bookmark.alarmDate else { return }
        
        let pending = await self.pendingNotificationRequests()
        let insertionIndex = pending.rightInsertionIndex(of: date)
        
        let request = makeNotificationRequest(
            id: String(bookmark.notice.id),
            body: bookmark.notice.title,
            badge: insertionIndex + 1,
            date: date,
            deeplink: "knutice://bookmark?nttId=\(bookmark.notice.id)"
        )
        
        // 새로운 NotificationRequest 추가
        try await add(request)
        
        // 기존 NotificationRequest Badge Count 1씩 증가
        try await modifyNotificationBadges(
            pending,
            startingAt: insertionIndex,
            by: +
        )
    }
    
    /// 스케줄링 되어 있는 알림의 badge를 1씩 감소
    public func updatePendingNotificationRequestBadges() async {
        do {
            let requests = await pendingNotificationRequests()
            try await modifyNotificationBadges(requests, startingAt: 0, by: -)
        } catch {
            print("UNUserNotificationCenter.updatePendingNotificationRequestsBadge Error: \(error)")
        }
    }
    
    /// 알림 아이콘 badge를 1씩 감소
    private func modifyNotificationBadges(
        _ requests: [UNNotificationRequest],
        startingAt index: Int,
        by operation: (Int, Int) -> Int
    ) async throws {
        guard index < requests.count else { return }
        
        for request in requests[index...] {
            if let badge = request.content.badge as? Int {
                let badge = operation(badge, 1)
                let newRequest = cloneRequest(from: request, badge: badge)
                
                try await add(newRequest)
            }
        }
    }
    
    /// 식별자를 통한 스케줄링 되어 있는 알림 삭제
    public func removeNotificationRequest(withId id: Int) async throws {
        let pendingNotificationRequests = await self.pendingNotificationRequests()
        let pos = pendingNotificationRequests.firstIndex(of: .init(id))
        
        if let pos {
            // 남아 있는 NotificationRequest Badge 업데이트
            try await self.modifyNotificationBadges(pendingNotificationRequests, startingAt: pos + 1, by: -)
            
            let identifiers: [String] = [String(id)]
            self.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    /// Remote Notification이 도착 후 Badge Count를 업데이트하는 메서드
    func updatePendingNotificationsBadgeAfterDelivered() async {
        let pendingNotificationRequests = await pendingNotificationRequests()
        guard !pendingNotificationRequests.isEmpty else { return }
        
        let deliveredNotifications = await deliveredNotifications()
        let count = deliveredNotifications.count + 1    //contentHandler가 호출될 때까지 count는 증가하지 않음
        
        pendingNotificationRequests.enumerated().forEach { (i, request) in
            let newRequest = cloneRequest(from: request, badge: count + 1 + i)
            
            self.add(newRequest)
        }
    }
    
    /// Foreground 상태 진입 시 스케줄 되어 있는 알림 Badge 재설정
    public func updatePendingNotificationsAfterForeground() async {
        let deliveredNotifications = await deliveredNotifications()
        let count = deliveredNotifications.count
        guard count > 0 else { return }    //전달된 알림이 없으면 바로 종료
        
        await pendingNotificationRequests().forEach { request in
            if let badge = request.content.badge as? Int {
                let newRequest = cloneRequest(from: request, badge: badge - count)
                
                self.add(newRequest)
            }
        }
    }
    
    private func makeNotificationRequest(
        id: String,
        body: String,
        badge: Int,
        date: Date,
        deeplink: String? = nil
    ) -> UNNotificationRequest {
        var userInfo: [AnyHashable: Any]? = nil
        
        if let deeplink {
            userInfo = ["deeplink": deeplink]
        }
        
        let content = makeNotificationContent(body: body, badge: badge, userInfo: userInfo)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        return UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    }
    
    private func makeNotificationContent(
        body: String,
        badge: Int,
        userInfo: [AnyHashable: Any]? = nil
    ) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "북마크 알림"
        content.body = body
        content.sound = .default
        content.badge = badge as NSNumber
        
        if let userInfo {
            content.userInfo = userInfo
        }
        
        return content
    }
    
    private func cloneRequest(from request: UNNotificationRequest, badge: Int) -> UNNotificationRequest {
        let content = makeNotificationContent(body: request.content.body, badge: badge, userInfo: request.content.userInfo)
        return UNNotificationRequest(identifier: request.identifier, content: content, trigger: request.trigger)
    }
}

fileprivate extension Array where Element == UNNotificationRequest {
    /// NotificationRequest가 위치할 인덱스 반환
    func rightInsertionIndex(of targetDate: Date) -> Int {
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
