//
//  BookmarkFormFactory.swift
//  KNNotice
//
//  Created by 이정훈 on 5/6/26.
//

import KNDomain
import UIKit

@MainActor
public protocol BookmarkFormFactory {
    func make(for notice: Notice) -> UIViewController
}
