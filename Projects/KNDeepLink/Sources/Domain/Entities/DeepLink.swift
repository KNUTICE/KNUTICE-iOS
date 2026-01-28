//
//  DeepLink.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/24/25.
//

import Foundation

public enum DeepLink: Sendable {
    case notice(nttId: Int, contentUrl: URL?)
    case meal
    case bookmark(nttId: Int)
    case unknown
}
