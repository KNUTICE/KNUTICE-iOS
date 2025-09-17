//
//  TopicSubscriptionRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

enum TopicType: String {
    case notice
    case major
    case meal
    
    var rawValue: String {
        switch self {
        case .notice:
            return "NOTICE"
        case .major:
            return "MAJOR"
        case .meal:
            return "MEAL"
        }
    }
}

protocol TopicSubscriptionRepository: Actor {
    func fetch(for topicType: TopicType) async throws -> [TopicSubscriptionKey]
    func update<T>(of type: TopicType, topic: T, isEnabled: Bool) async throws where T: RawRepresentable, T.RawValue == String
}
