//
//  FailSavingExistingBookmarkUseCase.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/23/25.
//

import Foundation
import KNUTICECore
@testable import KNUTICE

actor FailSavingExistingBookmarkUseCase: SaveBookmarkUseCase {
    func execute(_ bookmark: KNUTICECore.Bookmark) async throws {
        throw ExistingBookmarkError.alreadyExist(message: "이미 존재하는 북마크에요.")
    }
    
}
