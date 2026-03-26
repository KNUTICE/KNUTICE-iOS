//
//  DeepLinkManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/23/25.
//

import Combine
import Foundation
import KNUtility

/// A manager responsible for handling deep links and notification-based navigation.
///
/// This class is constrained to the `@MainActor` as it directly interacts with
/// the application's navigation state and UI flow.
@MainActor
public final class DeepLinkManager {
    /// The shared singleton instance.
    public static let shared = DeepLinkManager()
    
    /// A subject that broadcasts the latest notification payload.
    ///
    /// Use this to observe notification data across the app.
    /// Initial value is `nil`.
    public let notificationPublisher: CurrentValueSubject<[AnyHashable : Any]?, Never> = .init(nil)
    
    private init() {}
    
    /// Parses a given URL into a structured `DeepLink` type.
    ///
    /// This method extracts host and query parameters to determine the
    /// appropriate navigation destination.
    ///
    /// - Parameter url: The incoming deep link URL to be parsed.
    /// - Returns: A `DeepLink` case corresponding to the URL structure, or `.unknown` if the URL is invalid or unsupported.
    public func parse(_ url: URL) -> DeepLink {
        guard let host = url.host else { return .unknown }
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        
        switch host {            
        case "notice", "widget":
            let nttIdValue = queryItems?.first(where: { $0.name == "nttId" })?.value
            let contentURL = queryItems?.first(where: { $0.name == "contentUrl" })?.value
            
            if let nttIdValue, let nttId = Int(nttIdValue) {
                return .notice(nttId: nttId, contentUrl: URL(string: contentURL ?? ""))
            }
            
            return .unknown
            
        case "meal":
            let topic = queryItems?.first(where: { $0.name == "topic" })?.value
            
            guard let topic, let cafeteria = CafeteriaCategory(rawValue: topic) else { return .unknown }
            
            return .meal(cafeteria: cafeteria)
            
        case "bookmark":
            let nttIdValue = queryItems?.first(where: { $0.name == "nttId" })?.value
            
            if let nttIdValue, let nttId = Int(nttIdValue) {
                return .bookmark(nttId: nttId)
            }
            
            return .unknown
            
        case "reading-room":
            guard let roomId = queryItems?.first(where: { $0.name == "roomId" })?.value,
                  let seat = queryItems?.first(where: { $0.name == "seat" })?.value else {
                return .unknown
            }
            return .readingRoom(roomId: roomId, seat: seat)
            
        default:
            return .unknown
        }
    }
}
