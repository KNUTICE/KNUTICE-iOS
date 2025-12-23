//
//  DeleteBookmarkFailureUseCase.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/23/25.
//

import Foundation
import KNUTICECore
@testable import KNUTICE

actor DeleteBookmarkFailureUseCase: DeleteBookmarkUseCase {
    func execute(for bookmark: Bookmark) async throws {
        throw NSError(domain: "com.knutice.bookmark", code: -1)
    }
    
}

