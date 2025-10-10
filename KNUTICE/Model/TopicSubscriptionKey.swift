//
//  TopicSubscriptionKey.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/17/25.
//

import Foundation
import KNUTICECore

enum TopicSubscriptionKey: Sendable {
    case notice(NoticeCategory)
    case major(MajorCategory)
}
