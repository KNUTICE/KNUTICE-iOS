//
//  Errors.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/21/25.
//

import Foundation

enum ExistingBookmarkError: Error {
    case alreadyExist(message: String)
}
