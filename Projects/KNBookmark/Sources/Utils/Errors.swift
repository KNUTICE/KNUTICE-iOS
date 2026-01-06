//
//  Errors.swift
//  KNBookmark
//
//  Created by 이정훈 on 1/4/26.
//

import Foundation

public enum ExistingBookmarkError: Error {
    case alreadyExist(message: String)
}
